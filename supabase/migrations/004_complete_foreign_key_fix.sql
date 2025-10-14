-- Migration: Complete Foreign Key Constraints Fix
-- Description: Fixes ALL foreign key constraints to allow proper user deletion
-- Created: 2024-12-19
-- This migration resolves the error: "Unable to delete rows as one of them is currently referenced by a foreign key constraint"

-- =============================================
-- COMPLETE FOREIGN KEY CONSTRAINTS FIX
-- =============================================

-- 1. FIX AUDIT_LOGS TABLE (Main culprit)
-- This is the table causing the error you're seeing
ALTER TABLE public.audit_logs DROP CONSTRAINT IF EXISTS audit_logs_user_id_fkey;
ALTER TABLE public.audit_logs 
ADD CONSTRAINT audit_logs_user_id_fkey 
FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

-- 2. FIX USER_PROFILES TABLE (Already has CASCADE, but let's ensure it)
ALTER TABLE public.user_profiles DROP CONSTRAINT IF EXISTS user_profiles_user_id_fkey;
ALTER TABLE public.user_profiles 
ADD CONSTRAINT user_profiles_user_id_fkey 
FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

-- 3. FIX PLAYERS TABLE - created_by field
ALTER TABLE public.players DROP CONSTRAINT IF EXISTS players_created_by_fkey;
ALTER TABLE public.players 
ADD CONSTRAINT players_created_by_fkey 
FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

-- 4. FIX MEDIA_FILES TABLE - uploaded_by field
ALTER TABLE public.media_files DROP CONSTRAINT IF EXISTS media_files_uploaded_by_fkey;
ALTER TABLE public.media_files 
ADD CONSTRAINT media_files_uploaded_by_fkey 
FOREIGN KEY (uploaded_by) REFERENCES public.users(id) ON DELETE SET NULL;

-- 5. FIX PLAYLISTS TABLE - created_by field
ALTER TABLE public.playlists DROP CONSTRAINT IF EXISTS playlists_created_by_fkey;
ALTER TABLE public.playlists 
ADD CONSTRAINT playlists_created_by_fkey 
FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

-- 6. FIX SCHEDULES TABLE - created_by field
ALTER TABLE public.schedules DROP CONSTRAINT IF EXISTS schedules_created_by_fkey;
ALTER TABLE public.schedules 
ADD CONSTRAINT schedules_created_by_fkey 
FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

-- =============================================
-- VERIFICATION QUERIES
-- =============================================

-- Query to verify all foreign key constraints are properly set
-- You can run this after applying the migration to confirm everything is working
/*
SELECT 
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    rc.delete_rule
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
LEFT JOIN information_schema.referential_constraints AS rc
    ON tc.constraint_name = rc.constraint_name
    AND tc.table_schema = rc.constraint_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND ccu.table_name = 'users'
    AND tc.table_schema = 'public'
ORDER BY tc.table_name;
*/

-- =============================================
-- COMMENTS AND DOCUMENTATION
-- =============================================

COMMENT ON CONSTRAINT audit_logs_user_id_fkey ON public.audit_logs IS 
'Foreign key with CASCADE DELETE - when user is deleted, all their audit logs are deleted';

COMMENT ON CONSTRAINT user_profiles_user_id_fkey ON public.user_profiles IS 
'Foreign key with CASCADE DELETE - when user is deleted, their profile is deleted';

COMMENT ON CONSTRAINT players_created_by_fkey ON public.players IS 
'Foreign key with SET NULL DELETE - when user is deleted, created_by field is set to NULL (preserves player data)';

COMMENT ON CONSTRAINT media_files_uploaded_by_fkey ON public.media_files IS 
'Foreign key with SET NULL DELETE - when user is deleted, uploaded_by field is set to NULL (preserves media files)';

COMMENT ON CONSTRAINT playlists_created_by_fkey ON public.playlists IS 
'Foreign key with SET NULL DELETE - when user is deleted, created_by field is set to NULL (preserves playlists)';

COMMENT ON CONSTRAINT schedules_created_by_fkey ON public.schedules IS 
'Foreign key with SET NULL DELETE - when user is deleted, created_by field is set to NULL (preserves schedules)';

-- =============================================
-- SUCCESS MESSAGE
-- =============================================

-- This migration should resolve the error:
-- "Unable to delete rows as one of them is currently referenced by a foreign key constraint from the table audit_logs"
--
-- After applying this migration, you will be able to:
-- ✅ Delete users from the users table without foreign key errors
-- ✅ All audit logs related to the deleted user will be automatically removed
-- ✅ User profiles will be automatically removed when user is deleted
-- ✅ Players, media files, playlists, and schedules will be preserved with NULL references
--
-- To test: Try deleting a user from the Supabase table editor - it should work without errors!

