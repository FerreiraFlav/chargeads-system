-- =============================================
-- CRIAR USUÁRIO AGORA - SQL SIMPLES E DIRETO
-- =============================================
-- Execute este SQL no Supabase Dashboard

-- 1. Limpar usuários existentes
DELETE FROM public.user_profiles WHERE user_id IN (
    SELECT id FROM public.users WHERE email = 'admin@chargeads.com'
);
DELETE FROM public.users WHERE email = 'admin@chargeads.com';
DELETE FROM auth.users WHERE email = 'admin@chargeads.com';

-- 2. Criar usuário na auth.users (tabela de autenticação do Supabase)
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
    'admin@chargeads.com',
    crypt('123456', gen_salt('bf')),
    NOW(),
    NOW(),
    NOW(),
    '{"provider": "email", "providers": ["email"]}',
    '{"full_name": "Administrador"}',
    false,
    'authenticated'
);

-- 3. Criar usuário na nossa tabela public.users
INSERT INTO public.users (id, email, full_name, role, is_active, created_at, updated_at)
SELECT 
    id,
    email,
    raw_user_meta_data->>'full_name',
    'admin',
    true,
    NOW(),
    NOW()
FROM auth.users 
WHERE email = 'admin@chargeads.com';

-- 4. Verificar se foi criado
SELECT 
    'Usuário criado com sucesso!' as status,
    u.email,
    u.full_name,
    u.role,
    u.is_active
FROM public.users u
WHERE u.email = 'admin@chargeads.com';
