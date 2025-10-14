-- Migration: Initial Schema for ChargeADS System
-- Description: Creates the initial database schema with users, players, and system tables
-- Created: 2024-12-19

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================
-- USERS AND AUTHENTICATION TABLES
-- =============================================

-- Create custom users table (extends auth.users)
CREATE TABLE public.users (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    avatar_url TEXT,
    role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('admin', 'user', 'viewer')),
    is_active BOOLEAN DEFAULT true,
    last_login_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user profiles table for additional user data
CREATE TABLE public.user_profiles (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    company_name TEXT,
    phone TEXT,
    address TEXT,
    timezone TEXT DEFAULT 'America/Sao_Paulo',
    preferences JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- PLAYERS AND MONITORING TABLES
-- =============================================

-- Create players table
CREATE TABLE public.players (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    location TEXT,
    ip_address INET,
    port INTEGER DEFAULT 8080,
    status TEXT NOT NULL DEFAULT 'offline' CHECK (status IN ('online', 'offline', 'unstable')),
    is_active BOOLEAN DEFAULT true,
    last_seen_at TIMESTAMP WITH TIME ZONE,
    created_by UUID REFERENCES public.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create player statistics table
CREATE TABLE public.player_statistics (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    player_id UUID REFERENCES public.players(id) ON DELETE CASCADE,
    uptime_percentage DECIMAL(5,2) DEFAULT 0.00,
    total_uptime INTERVAL DEFAULT '0 seconds',
    total_downtime INTERVAL DEFAULT '0 seconds',
    last_status_change TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create player logs table for status changes
CREATE TABLE public.player_logs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    player_id UUID REFERENCES public.players(id) ON DELETE CASCADE,
    status TEXT NOT NULL CHECK (status IN ('online', 'offline', 'unstable')),
    message TEXT,
    ip_address INET,
    response_time INTEGER, -- in milliseconds
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- MEDIA AND CONTENT TABLES
-- =============================================

-- Create media files table
CREATE TABLE public.media_files (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    filename TEXT NOT NULL,
    original_filename TEXT NOT NULL,
    file_path TEXT NOT NULL,
    file_size BIGINT NOT NULL,
    mime_type TEXT NOT NULL,
    duration INTEGER, -- in seconds for video/audio files
    resolution TEXT, -- for video files (e.g., "1920x1080")
    thumbnail_path TEXT,
    is_active BOOLEAN DEFAULT true,
    uploaded_by UUID REFERENCES public.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create playlists table
CREATE TABLE public.playlists (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_by UUID REFERENCES public.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create playlist items table (junction table)
CREATE TABLE public.playlist_items (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    playlist_id UUID REFERENCES public.playlists(id) ON DELETE CASCADE,
    media_file_id UUID REFERENCES public.media_files(id) ON DELETE CASCADE,
    order_index INTEGER NOT NULL,
    duration INTEGER, -- override duration for this specific item
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(playlist_id, order_index)
);

-- =============================================
-- SCHEDULING AND PROGRAMMING TABLES
-- =============================================

-- Create schedules table
CREATE TABLE public.schedules (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_recurring BOOLEAN DEFAULT false,
    recurrence_pattern TEXT, -- daily, weekly, monthly
    is_active BOOLEAN DEFAULT true,
    created_by UUID REFERENCES public.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create schedule assignments table (which players use which schedules)
CREATE TABLE public.schedule_assignments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    schedule_id UUID REFERENCES public.schedules(id) ON DELETE CASCADE,
    player_id UUID REFERENCES public.players(id) ON DELETE CASCADE,
    playlist_id UUID REFERENCES public.playlists(id) ON DELETE CASCADE,
    priority INTEGER DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(schedule_id, player_id)
);

-- =============================================
-- SYSTEM CONFIGURATION TABLES
-- =============================================

-- Create system settings table
CREATE TABLE public.system_settings (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    key TEXT UNIQUE NOT NULL,
    value JSONB NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create audit logs table
CREATE TABLE public.audit_logs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id),
    action TEXT NOT NULL,
    resource_type TEXT NOT NULL,
    resource_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- INDEXES FOR PERFORMANCE
-- =============================================

-- Users indexes
CREATE INDEX idx_users_email ON public.users(email);
CREATE INDEX idx_users_role ON public.users(role);
CREATE INDEX idx_users_active ON public.users(is_active);

-- Players indexes
CREATE INDEX idx_players_status ON public.players(status);
CREATE INDEX idx_players_active ON public.players(is_active);
CREATE INDEX idx_players_created_by ON public.players(created_by);

-- Player logs indexes
CREATE INDEX idx_player_logs_player_id ON public.player_logs(player_id);
CREATE INDEX idx_player_logs_created_at ON public.player_logs(created_at);
CREATE INDEX idx_player_logs_status ON public.player_logs(status);

-- Media files indexes
CREATE INDEX idx_media_files_active ON public.media_files(is_active);
CREATE INDEX idx_media_files_mime_type ON public.media_files(mime_type);
CREATE INDEX idx_media_files_uploaded_by ON public.media_files(uploaded_by);

-- Playlist indexes
CREATE INDEX idx_playlist_items_playlist_id ON public.playlist_items(playlist_id);
CREATE INDEX idx_playlist_items_order ON public.playlist_items(playlist_id, order_index);

-- Schedule indexes
CREATE INDEX idx_schedules_active ON public.schedules(is_active);
CREATE INDEX idx_schedules_dates ON public.schedules(start_date, end_date);
CREATE INDEX idx_schedule_assignments_player ON public.schedule_assignments(player_id);

-- Audit logs indexes
CREATE INDEX idx_audit_logs_user_id ON public.audit_logs(user_id);
CREATE INDEX idx_audit_logs_created_at ON public.audit_logs(created_at);
CREATE INDEX idx_audit_logs_resource ON public.audit_logs(resource_type, resource_id);

-- =============================================
-- TRIGGERS FOR UPDATED_AT
-- =============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at triggers to all tables
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON public.user_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_players_updated_at BEFORE UPDATE ON public.players FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_player_statistics_updated_at BEFORE UPDATE ON public.player_statistics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_media_files_updated_at BEFORE UPDATE ON public.media_files FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_playlists_updated_at BEFORE UPDATE ON public.playlists FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_schedules_updated_at BEFORE UPDATE ON public.schedules FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_system_settings_updated_at BEFORE UPDATE ON public.system_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- INITIAL DATA
-- =============================================

-- Insert default system settings
INSERT INTO public.system_settings (key, value, description, is_public) VALUES
('system_name', '"ChargeADS"', 'Nome do sistema', true),
('timezone', '"America/Sao_Paulo"', 'Fuso horário padrão', true),
('max_file_size', '104857600', 'Tamanho máximo de arquivo em bytes (100MB)', false),
('allowed_file_types', '["image/jpeg", "image/png", "image/gif", "video/mp4", "video/webm", "video/avi", "audio/mp3", "audio/wav"]', 'Tipos de arquivo permitidos', false),
('player_check_interval', '30', 'Intervalo de verificação dos players em segundos', false),
('retention_days', '90', 'Dias para manter logs de auditoria', false);

-- =============================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =============================================

-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.players ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.player_statistics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.player_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.media_files ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.playlists ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.playlist_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.schedule_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.system_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can view their own profile" ON public.users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update their own profile" ON public.users FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Admins can view all users" ON public.users FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin')
);
CREATE POLICY "Admins can update all users" ON public.users FOR UPDATE USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin')
);

-- User profiles policies
CREATE POLICY "Users can view their own profile" ON public.user_profiles FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update their own profile" ON public.user_profiles FOR ALL USING (auth.uid() = user_id);

-- Players policies
CREATE POLICY "Authenticated users can view players" ON public.players FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can manage players" ON public.players FOR ALL USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin')
);

-- Player statistics policies
CREATE POLICY "Authenticated users can view player statistics" ON public.player_statistics FOR SELECT USING (auth.role() = 'authenticated');

-- Player logs policies
CREATE POLICY "Authenticated users can view player logs" ON public.player_logs FOR SELECT USING (auth.role() = 'authenticated');

-- Media files policies
CREATE POLICY "Authenticated users can view media files" ON public.media_files FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can manage media files" ON public.media_files FOR ALL USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin')
);

-- Playlists policies
CREATE POLICY "Authenticated users can view playlists" ON public.playlists FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can manage playlists" ON public.playlists FOR ALL USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin')
);

-- Playlist items policies
CREATE POLICY "Authenticated users can view playlist items" ON public.playlist_items FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can manage playlist items" ON public.playlist_items FOR ALL USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin')
);

-- Schedules policies
CREATE POLICY "Authenticated users can view schedules" ON public.schedules FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can manage schedules" ON public.schedules FOR ALL USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin')
);

-- Schedule assignments policies
CREATE POLICY "Authenticated users can view schedule assignments" ON public.schedule_assignments FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can manage schedule assignments" ON public.schedule_assignments FOR ALL USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin')
);

-- System settings policies
CREATE POLICY "Public settings are viewable by all" ON public.system_settings FOR SELECT USING (is_public = true);
CREATE POLICY "Admins can manage all settings" ON public.system_settings FOR ALL USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin')
);

-- Audit logs policies (read-only for most users)
CREATE POLICY "Admins can view audit logs" ON public.audit_logs FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin')
);

-- =============================================
-- FUNCTIONS FOR AUTHENTICATION
-- =============================================

-- Function to handle new user registration
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.users (id, email, full_name, role)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
        'user'
    );
    
    INSERT INTO public.user_profiles (user_id)
    VALUES (NEW.id);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to automatically create user record
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to update last login
CREATE OR REPLACE FUNCTION public.update_last_login()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.users 
    SET last_login_at = NOW()
    WHERE id = NEW.user_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================
-- VIEWS FOR COMMON QUERIES
-- =============================================

-- View for player status overview
CREATE VIEW public.player_status_overview AS
SELECT 
    p.id,
    p.name,
    p.status,
    p.last_seen_at,
    ps.uptime_percentage,
    ps.total_uptime,
    ps.last_status_change,
    CASE 
        WHEN p.status = 'online' THEN 'success'
        WHEN p.status = 'unstable' THEN 'warning'
        ELSE 'danger'
    END as status_color
FROM public.players p
LEFT JOIN public.player_statistics ps ON p.id = ps.player_id
WHERE p.is_active = true;

-- View for recent player logs
CREATE VIEW public.recent_player_logs AS
SELECT 
    pl.id,
    pl.player_id,
    p.name as player_name,
    pl.status,
    pl.message,
    pl.response_time,
    pl.created_at
FROM public.player_logs pl
JOIN public.players p ON pl.player_id = p.id
WHERE pl.created_at >= NOW() - INTERVAL '24 hours'
ORDER BY pl.created_at DESC;

-- =============================================
-- COMMENTS
-- =============================================

COMMENT ON TABLE public.users IS 'User accounts extending Supabase auth.users';
COMMENT ON TABLE public.user_profiles IS 'Additional user profile information';
COMMENT ON TABLE public.players IS 'Digital signage players/devices';
COMMENT ON TABLE public.player_statistics IS 'Statistics and uptime data for players';
COMMENT ON TABLE public.player_logs IS 'Log of player status changes and events';
COMMENT ON TABLE public.media_files IS 'Media files uploaded to the system';
COMMENT ON TABLE public.playlists IS 'Collections of media files for playback';
COMMENT ON TABLE public.playlist_items IS 'Items within playlists with ordering';
COMMENT ON TABLE public.schedules IS 'Scheduling rules for content playback';
COMMENT ON TABLE public.schedule_assignments IS 'Assignment of schedules to players';
COMMENT ON TABLE public.system_settings IS 'System configuration settings';
COMMENT ON TABLE public.audit_logs IS 'Audit trail for system changes';
