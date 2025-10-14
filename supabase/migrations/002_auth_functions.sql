-- Migration: Authentication Functions and Policies
-- Description: Enhanced authentication functions and user management
-- Created: 2024-12-19

-- =============================================
-- AUTHENTICATION FUNCTIONS
-- =============================================

-- Function to get current user profile
CREATE OR REPLACE FUNCTION public.get_user_profile()
RETURNS TABLE (
    id UUID,
    email TEXT,
    full_name TEXT,
    avatar_url TEXT,
    role TEXT,
    is_active BOOLEAN,
    last_login_at TIMESTAMP WITH TIME ZONE,
    company_name TEXT,
    phone TEXT,
    timezone TEXT,
    preferences JSONB
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.id,
        u.email,
        u.full_name,
        u.avatar_url,
        u.role,
        u.is_active,
        u.last_login_at,
        up.company_name,
        up.phone,
        up.timezone,
        up.preferences
    FROM public.users u
    LEFT JOIN public.user_profiles up ON u.id = up.user_id
    WHERE u.id = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to update user profile
CREATE OR REPLACE FUNCTION public.update_user_profile(
    p_full_name TEXT DEFAULT NULL,
    p_company_name TEXT DEFAULT NULL,
    p_phone TEXT DEFAULT NULL,
    p_timezone TEXT DEFAULT NULL,
    p_preferences JSONB DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    user_id UUID;
BEGIN
    user_id := auth.uid();
    
    IF user_id IS NULL THEN
        RETURN FALSE;
    END IF;
    
    -- Update users table
    IF p_full_name IS NOT NULL THEN
        UPDATE public.users 
        SET full_name = p_full_name, updated_at = NOW()
        WHERE id = user_id;
    END IF;
    
    -- Update user_profiles table
    UPDATE public.user_profiles 
    SET 
        company_name = COALESCE(p_company_name, company_name),
        phone = COALESCE(p_phone, phone),
        timezone = COALESCE(p_timezone, timezone),
        preferences = COALESCE(p_preferences, preferences),
        updated_at = NOW()
    WHERE user_id = user_id;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if user is admin
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.users 
        WHERE id = auth.uid() AND role = 'admin'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get user role
CREATE OR REPLACE FUNCTION public.get_user_role()
RETURNS TEXT AS $$
DECLARE
    user_role TEXT;
BEGIN
    SELECT role INTO user_role
    FROM public.users
    WHERE id = auth.uid();
    
    RETURN COALESCE(user_role, 'anonymous');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to log user activity
CREATE OR REPLACE FUNCTION public.log_user_activity(
    p_action TEXT,
    p_resource_type TEXT DEFAULT NULL,
    p_resource_id UUID DEFAULT NULL,
    p_details JSONB DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO public.audit_logs (
        user_id,
        action,
        resource_type,
        resource_id,
        new_values,
        ip_address,
        user_agent
    ) VALUES (
        auth.uid(),
        p_action,
        p_resource_type,
        p_resource_id,
        p_details,
        inet_client_addr(),
        current_setting('request.headers', true)::json->>'user-agent'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to update last login
CREATE OR REPLACE FUNCTION public.update_last_login()
RETURNS VOID AS $$
BEGIN
    UPDATE public.users 
    SET last_login_at = NOW()
    WHERE id = auth.uid();
    
    -- Log the login activity
    PERFORM public.log_user_activity('login', 'user', auth.uid());
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to handle user logout
CREATE OR REPLACE FUNCTION public.handle_logout()
RETURNS VOID AS $$
BEGIN
    -- Log the logout activity
    PERFORM public.log_user_activity('logout', 'user', auth.uid());
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================
-- PLAYER MANAGEMENT FUNCTIONS
-- =============================================

-- Function to update player status
CREATE OR REPLACE FUNCTION public.update_player_status(
    p_player_id UUID,
    p_status TEXT,
    p_message TEXT DEFAULT NULL,
    p_response_time INTEGER DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    player_exists BOOLEAN;
BEGIN
    -- Check if player exists and user has permission
    SELECT EXISTS (
        SELECT 1 FROM public.players 
        WHERE id = p_player_id AND is_active = true
    ) INTO player_exists;
    
    IF NOT player_exists THEN
        RETURN FALSE;
    END IF;
    
    -- Update player status
    UPDATE public.players 
    SET 
        status = p_status,
        last_seen_at = CASE WHEN p_status = 'online' THEN NOW() ELSE last_seen_at END,
        updated_at = NOW()
    WHERE id = p_player_id;
    
    -- Log the status change
    INSERT INTO public.player_logs (
        player_id,
        status,
        message,
        ip_address,
        response_time
    ) VALUES (
        p_player_id,
        p_status,
        p_message,
        inet_client_addr(),
        p_response_time
    );
    
    -- Update statistics
    INSERT INTO public.player_statistics (player_id, last_status_change)
    VALUES (p_player_id, NOW())
    ON CONFLICT (player_id) 
    DO UPDATE SET 
        last_status_change = NOW(),
        updated_at = NOW();
    
    -- Log the activity
    PERFORM public.log_user_activity(
        'update_player_status',
        'player',
        p_player_id,
        json_build_object('status', p_status, 'message', p_message)
    );
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get player dashboard data
CREATE OR REPLACE FUNCTION public.get_player_dashboard()
RETURNS TABLE (
    total_players BIGINT,
    online_players BIGINT,
    offline_players BIGINT,
    unstable_players BIGINT,
    avg_uptime DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_players,
        COUNT(*) FILTER (WHERE status = 'online') as online_players,
        COUNT(*) FILTER (WHERE status = 'offline') as offline_players,
        COUNT(*) FILTER (WHERE status = 'unstable') as unstable_players,
        AVG(ps.uptime_percentage) as avg_uptime
    FROM public.players p
    LEFT JOIN public.player_statistics ps ON p.id = ps.player_id
    WHERE p.is_active = true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================
-- MEDIA MANAGEMENT FUNCTIONS
-- =============================================

-- Function to upload media file
CREATE OR REPLACE FUNCTION public.upload_media_file(
    p_filename TEXT,
    p_original_filename TEXT,
    p_file_path TEXT,
    p_file_size BIGINT,
    p_mime_type TEXT,
    p_duration INTEGER DEFAULT NULL,
    p_resolution TEXT DEFAULT NULL,
    p_thumbnail_path TEXT DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    media_id UUID;
BEGIN
    -- Check if user is authenticated
    IF auth.uid() IS NULL THEN
        RAISE EXCEPTION 'User must be authenticated to upload files';
    END IF;
    
    -- Insert media file
    INSERT INTO public.media_files (
        filename,
        original_filename,
        file_path,
        file_size,
        mime_type,
        duration,
        resolution,
        thumbnail_path,
        uploaded_by
    ) VALUES (
        p_filename,
        p_original_filename,
        p_file_path,
        p_file_size,
        p_mime_type,
        p_duration,
        p_resolution,
        p_thumbnail_path,
        auth.uid()
    ) RETURNING id INTO media_id;
    
    -- Log the activity
    PERFORM public.log_user_activity(
        'upload_media_file',
        'media_file',
        media_id,
        json_build_object(
            'filename', p_filename,
            'file_size', p_file_size,
            'mime_type', p_mime_type
        )
    );
    
    RETURN media_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================
-- ENHANCED RLS POLICIES
-- =============================================

-- Drop existing policies to recreate them with better logic
DROP POLICY IF EXISTS "Users can view their own profile" ON public.users;
DROP POLICY IF EXISTS "Users can update their own profile" ON public.users;
DROP POLICY IF EXISTS "Admins can view all users" ON public.users;
DROP POLICY IF EXISTS "Admins can update all users" ON public.users;

-- Enhanced user policies
CREATE POLICY "Users can view their own profile" ON public.users 
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON public.users 
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Admins can view all users" ON public.users 
    FOR SELECT USING (public.is_admin());

CREATE POLICY "Admins can update all users" ON public.users 
    FOR UPDATE USING (public.is_admin());

CREATE POLICY "Admins can insert users" ON public.users 
    FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY "Admins can delete users" ON public.users 
    FOR DELETE USING (public.is_admin());

-- Enhanced player policies
DROP POLICY IF EXISTS "Authenticated users can view players" ON public.players;
DROP POLICY IF EXISTS "Admins can manage players" ON public.players;

CREATE POLICY "Authenticated users can view players" ON public.players 
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Admins can manage players" ON public.players 
    FOR ALL USING (public.is_admin());

-- Enhanced media file policies
DROP POLICY IF EXISTS "Authenticated users can view media files" ON public.media_files;
DROP POLICY IF EXISTS "Admins can manage media files" ON public.media_files;

CREATE POLICY "Authenticated users can view media files" ON public.media_files 
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can upload media files" ON public.media_files 
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can update their own media files" ON public.media_files 
    FOR UPDATE USING (auth.uid() = uploaded_by);

CREATE POLICY "Admins can manage all media files" ON public.media_files 
    FOR ALL USING (public.is_admin());

-- =============================================
-- TRIGGERS FOR AUTOMATIC LOGGING
-- =============================================

-- Function to log changes to players table
CREATE OR REPLACE FUNCTION public.log_player_changes()
RETURNS TRIGGER AS $$
BEGIN
    -- Log the change
    PERFORM public.log_user_activity(
        TG_OP,
        'player',
        COALESCE(NEW.id, OLD.id),
        json_build_object(
            'old_values', row_to_json(OLD),
            'new_values', row_to_json(NEW)
        )
    );
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create triggers for player changes
CREATE TRIGGER log_player_changes_trigger
    AFTER INSERT OR UPDATE OR DELETE ON public.players
    FOR EACH ROW EXECUTE FUNCTION public.log_player_changes();

-- Function to log changes to media files table
CREATE OR REPLACE FUNCTION public.log_media_changes()
RETURNS TRIGGER AS $$
BEGIN
    -- Log the change
    PERFORM public.log_user_activity(
        TG_OP,
        'media_file',
        COALESCE(NEW.id, OLD.id),
        json_build_object(
            'old_values', row_to_json(OLD),
            'new_values', row_to_json(NEW)
        )
    );
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create triggers for media file changes
CREATE TRIGGER log_media_changes_trigger
    AFTER INSERT OR UPDATE OR DELETE ON public.media_files
    FOR EACH ROW EXECUTE FUNCTION public.log_media_changes();

-- =============================================
-- VIEWS FOR DASHBOARD
-- =============================================

-- Enhanced player status overview with more details
CREATE OR REPLACE VIEW public.player_status_overview AS
SELECT 
    p.id,
    p.name,
    p.description,
    p.location,
    p.ip_address,
    p.status,
    p.last_seen_at,
    ps.uptime_percentage,
    ps.total_uptime,
    ps.total_downtime,
    ps.last_status_change,
    CASE 
        WHEN p.status = 'online' THEN 'success'
        WHEN p.status = 'unstable' THEN 'warning'
        ELSE 'danger'
    END as status_color,
    CASE 
        WHEN p.last_seen_at > NOW() - INTERVAL '5 minutes' THEN 'online'
        WHEN p.last_seen_at > NOW() - INTERVAL '1 hour' THEN 'recent'
        ELSE 'offline'
    END as connection_status
FROM public.players p
LEFT JOIN public.player_statistics ps ON p.id = ps.player_id
WHERE p.is_active = true;

-- View for recent activity
CREATE OR REPLACE VIEW public.recent_activity AS
SELECT 
    al.id,
    al.action,
    al.resource_type,
    al.resource_id,
    al.created_at,
    u.email as user_email,
    u.full_name as user_name,
    al.new_values
FROM public.audit_logs al
LEFT JOIN public.users u ON al.user_id = u.id
WHERE al.created_at >= NOW() - INTERVAL '24 hours'
ORDER BY al.created_at DESC;

-- View for system statistics
CREATE OR REPLACE VIEW public.system_statistics AS
SELECT 
    (SELECT COUNT(*) FROM public.users WHERE is_active = true) as total_users,
    (SELECT COUNT(*) FROM public.players WHERE is_active = true) as total_players,
    (SELECT COUNT(*) FROM public.players WHERE status = 'online' AND is_active = true) as online_players,
    (SELECT COUNT(*) FROM public.media_files WHERE is_active = true) as total_media_files,
    (SELECT COUNT(*) FROM public.playlists WHERE is_active = true) as total_playlists,
    (SELECT COUNT(*) FROM public.schedules WHERE is_active = true) as total_schedules,
    (SELECT AVG(uptime_percentage) FROM public.player_statistics) as avg_uptime,
    (SELECT COUNT(*) FROM public.audit_logs WHERE created_at >= NOW() - INTERVAL '24 hours') as recent_activities;

-- =============================================
-- COMMENTS
-- =============================================

COMMENT ON FUNCTION public.get_user_profile() IS 'Returns the current user profile with all related information';
COMMENT ON FUNCTION public.update_user_profile(TEXT, TEXT, TEXT, TEXT, JSONB) IS 'Updates user profile information';
COMMENT ON FUNCTION public.is_admin() IS 'Checks if the current user has admin role';
COMMENT ON FUNCTION public.get_user_role() IS 'Returns the role of the current user';
COMMENT ON FUNCTION public.log_user_activity(TEXT, TEXT, UUID, JSONB) IS 'Logs user activity for audit purposes';
COMMENT ON FUNCTION public.update_player_status(UUID, TEXT, TEXT, INTEGER) IS 'Updates player status and logs the change';
COMMENT ON FUNCTION public.get_player_dashboard() IS 'Returns dashboard statistics for players';
COMMENT ON FUNCTION public.upload_media_file(TEXT, TEXT, TEXT, BIGINT, TEXT, INTEGER, TEXT, TEXT) IS 'Handles media file upload with proper logging';
