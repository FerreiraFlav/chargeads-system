-- =============================================
-- SQL PARA EXECUTAR NO SUPABASE DASHBOARD AGORA
-- =============================================
-- Este SQL vai corrigir o problema que você está vendo na tabela

-- 1. Remove a constraint problemática
ALTER TABLE public.audit_logs DROP CONSTRAINT IF EXISTS audit_logs_user_id_fkey;

-- 2. Recria a constraint com ON DELETE CASCADE
ALTER TABLE public.audit_logs 
ADD CONSTRAINT audit_logs_user_id_fkey 
FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

-- 3. Verifica se foi aplicado corretamente (opcional - você pode executar depois)
SELECT 
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    rc.delete_rule
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
LEFT JOIN information_schema.referential_constraints AS rc
    ON tc.constraint_name = rc.constraint_name
WHERE tc.constraint_name = 'audit_logs_user_id_fkey'
    AND tc.table_schema = 'public';
