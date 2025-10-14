-- Migration: Fix Foreign Key Constraints
-- Description: Adds ON DELETE CASCADE to foreign key constraints to allow user deletion
-- Created: 2024-12-19

-- =============================================
-- FIX AUDIT LOGS FOREIGN KEY CONSTRAINT
-- =============================================

-- Drop the existing foreign key constraint
ALTER TABLE public.audit_logs DROP CONSTRAINT IF EXISTS audit_logs_user_id_fkey;

-- Recreate the foreign key constraint with ON DELETE CASCADE
ALTER TABLE public.audit_logs 
ADD CONSTRAINT audit_logs_user_id_fkey 
FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

-- =============================================
-- FIX OTHER FOREIGN KEY CONSTRAINTS
-- =============================================

-- Fix players table created_by foreign key
ALTER TABLE public.players DROP CONSTRAINT IF EXISTS players_created_by_fkey;
ALTER TABLE public.players 
ADD CONSTRAINT players_created_by_fkey 
FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

-- Fix media_files table uploaded_by foreign key
ALTER TABLE public.media_files DROP CONSTRAINT IF EXISTS media_files_uploaded_by_fkey;
ALTER TABLE public.media_files 
ADD CONSTRAINT media_files_uploaded_by_fkey 
FOREIGN KEY (uploaded_by) REFERENCES public.users(id) ON DELETE SET NULL;

-- Fix playlists table created_by foreign key
ALTER TABLE public.playlists DROP CONSTRAINT IF EXISTS playlists_created_by_fkey;
ALTER TABLE public.playlists 
ADD CONSTRAINT playlists_created_by_fkey 
FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

-- Fix schedules table created_by foreign key
ALTER TABLE public.schedules DROP CONSTRAINT IF EXISTS schedules_created_by_fkey;
ALTER TABLE public.schedules 
ADD CONSTRAINT schedules_created_by_fkey 
FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

-- =============================================
-- COMMENTS
-- =============================================

COMMENT ON CONSTRAINT audit_logs_user_id_fkey ON public.audit_logs IS 'Foreign key constraint with CASCADE delete to allow user deletion';
COMMENT ON CONSTRAINT players_created_by_fkey ON public.players IS 'Foreign key constraint with SET NULL delete to preserve player records';
COMMENT ON CONSTRAINT media_files_uploaded_by_fkey ON public.media_files IS 'Foreign key constraint with SET NULL delete to preserve media files';
COMMENT ON CONSTRAINT playlists_created_by_fkey ON public.playlists IS 'Foreign key constraint with SET NULL delete to preserve playlists';
COMMENT ON CONSTRAINT schedules_created_by_fkey ON public.schedules IS 'Foreign key constraint with SET NULL delete to preserve schedules';

