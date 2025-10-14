-- =============================================
-- TESTE DE CRIAÇÃO DE USUÁRIO
-- =============================================
-- Execute este SQL no Supabase Dashboard para testar a criação de usuários

-- 1. Verificar se há usuários existentes
SELECT id, email, role, is_active, created_at 
FROM public.users 
ORDER BY created_at DESC;

-- 2. Verificar configurações de autenticação
SELECT * FROM auth.config;

-- 3. Verificar se o registro está habilitado
SELECT key, value 
FROM public.system_settings 
WHERE key LIKE '%signup%' OR key LIKE '%register%';

-- 4. Criar um usuário de teste manualmente (se necessário)
-- Descomente as linhas abaixo se precisar criar um usuário de teste:

/*
INSERT INTO auth.users (
    id,
    email,
    encrypted_password,
    email_confirmed_at,
    created_at,
    updated_at,
    raw_app_meta_data,
    raw_user_meta_data,
    is_super_admin,
    role
) VALUES (
    gen_random_uuid(),
    'teste@chargeads.com',
    crypt('123456', gen_salt('bf')),
    NOW(),
    NOW(),
    NOW(),
    '{"provider": "email", "providers": ["email"]}',
    '{"full_name": "Usuário de Teste"}',
    false,
    'authenticated'
);

-- Depois criar o perfil na tabela users
INSERT INTO public.users (id, email, full_name, role, is_active)
SELECT 
    id,
    email,
    raw_user_meta_data->>'full_name',
    'user',
    true
FROM auth.users 
WHERE email = 'teste@chargeads.com'
AND id NOT IN (SELECT id FROM public.users);
*/

-- 5. Verificar logs de auditoria recentes
SELECT 
    al.action,
    al.resource_type,
    al.created_at,
    u.email as user_email
FROM public.audit_logs al
LEFT JOIN public.users u ON al.user_id = u.id
WHERE al.created_at >= NOW() - INTERVAL '1 hour'
ORDER BY al.created_at DESC;
