-- =============================================
-- FIX USER DELETION - SUPABASE DASHBOARD SQL
-- =============================================
-- Execute this SQL in your Supabase Dashboard SQL Editor
-- This will fix the foreign key constraint error when deleting users

-- Step 1: Fix the main culprit - audit_logs table
ALTER TABLE public.audit_logs DROP CONSTRAINT IF EXISTS audit_logs_user_id_fkey;
ALTER TABLE public.audit_logs 
ADD CONSTRAINT audit_logs_user_id_fkey 
FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

-- Step 2: Fix user_profiles table
ALTER TABLE public.user_profiles DROP CONSTRAINT IF EXISTS user_profiles_user_id_fkey;
ALTER TABLE public.user_profiles 
ADD CONSTRAINT user_profiles_user_id_fkey 
FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

-- Step 3: Fix players table
ALTER TABLE public.players DROP CONSTRAINT IF EXISTS players_created_by_fkey;
ALTER TABLE public.players 
ADD CONSTRAINT players_created_by_fkey 
FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

-- Step 4: Fix media_files table
ALTER TABLE public.media_files DROP CONSTRAINT IF EXISTS media_files_uploaded_by_fkey;
ALTER TABLE public.media_files 
ADD CONSTRAINT media_files_uploaded_by_fkey 
FOREIGN KEY (uploaded_by) REFERENCES public.users(id) ON DELETE SET NULL;

-- Step 5: Fix playlists table
ALTER TABLE public.playlists DROP CONSTRAINT IF EXISTS playlists_created_by_fkey;
ALTER TABLE public.playlists 
ADD CONSTRAINT playlists_created_by_fkey 
FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

-- Step 6: Fix schedules table
ALTER TABLE public.schedules DROP CONSTRAINT IF EXISTS schedules_created_by_fkey;
ALTER TABLE public.schedules 
ADD CONSTRAINT schedules_created_by_fkey 
FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

-- =============================================
-- VERIFICATION (Optional - run this to confirm)
-- =============================================
-- Uncomment the lines below to verify the constraints are set correctly:

/*
SELECT 
    tc.table_name,
    tc.constraint_name,
    rc.delete_rule
FROM information_schema.table_constraints AS tc 
LEFT JOIN information_schema.referential_constraints AS rc
    ON tc.constraint_name = rc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_schema = 'public'
    AND tc.constraint_name LIKE '%user%'
ORDER BY tc.table_name;
*/

-- ✅ DONE! You should now be able to delete users without foreign key errors.

