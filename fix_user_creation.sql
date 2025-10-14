-- =============================================
-- CORRIGIR CRIAÇÃO DE USUÁRIO
-- =============================================
-- Execute este SQL no Supabase Dashboard

-- 1. Verificar se já existe algum usuário
SELECT 'auth.users' as tabela, id, email, email_confirmed_at 
FROM auth.users 
WHERE email = 'teste@chargeads.com'
UNION ALL
SELECT 'public.users' as tabela, id, email, created_at::text 
FROM public.users 
WHERE email = 'teste@chargeads.com';

-- 2. Deletar usuário existente se houver (caso esteja corrompido)
DELETE FROM public.users WHERE email = 'teste@chargeads.com';
DELETE FROM auth.users WHERE email = 'teste@chargeads.com';

-- 3. Criar usuário corretamente na auth.users
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

-- 4. Criar usuário na tabela public.users
INSERT INTO public.users (id, email, full_name, role, is_active)
SELECT 
    id,
    email,
    raw_user_meta_data->>'full_name',
    'user',
    true
FROM auth.users 
WHERE email = 'teste@chargeads.com';

-- 5. Criar perfil na user_profiles
INSERT INTO public.user_profiles (user_id, company_name, phone, timezone)
SELECT 
    id,
    'Empresa de Teste',
    '(11) 99999-9999',
    'America/Sao_Paulo'
FROM public.users 
WHERE email = 'teste@chargeads.com';

-- 6. Verificar se foi criado corretamente
SELECT 
    'auth.users' as tabela,
    id,
    email,
    email_confirmed_at
FROM auth.users 
WHERE email = 'teste@chargeads.com'
UNION ALL
SELECT 
    'public.users' as tabela,
    id,
    email,
    role
FROM public.users 
WHERE email = 'teste@chargeads.com'
UNION ALL
SELECT 
    'user_profiles' as tabela,
    user_id::text,
    company_name,
    phone
FROM public.user_profiles up
JOIN public.users u ON up.user_id = u.id
WHERE u.email = 'teste@chargeads.com';
