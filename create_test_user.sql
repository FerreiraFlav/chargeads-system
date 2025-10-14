-- =============================================
-- CRIAR USUÁRIO DE TESTE
-- =============================================
-- Execute este SQL no Supabase Dashboard para criar um usuário de teste

-- 1. Primeiro, criar o usuário na tabela auth.users
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

-- 2. Depois criar o perfil na tabela public.users
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

-- 3. Criar perfil adicional na tabela user_profiles
INSERT INTO public.user_profiles (user_id, company_name, phone, timezone)
SELECT 
    id,
    'Empresa de Teste',
    '(11) 99999-9999',
    'America/Sao_Paulo'
FROM public.users 
WHERE email = 'teste@chargeads.com'
AND id NOT IN (SELECT user_id FROM public.user_profiles);

-- 4. Verificar se o usuário foi criado corretamente
SELECT 
    u.id,
    u.email,
    u.full_name,
    u.role,
    u.is_active,
    up.company_name,
    up.phone
FROM public.users u
LEFT JOIN public.user_profiles up ON u.id = up.user_id
WHERE u.email = 'teste@chargeads.com';
