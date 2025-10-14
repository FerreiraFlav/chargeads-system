-- =============================================
-- CRIAR USUÁRIO ADMIN
-- =============================================
-- Execute este SQL para criar um usuário admin funcional

-- 1. Deletar admin existente se houver
DELETE FROM public.users WHERE email = 'admin@chargeads.com';
DELETE FROM auth.users WHERE email = 'admin@chargeads.com';

-- 2. Criar usuário admin na auth.users
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

-- 3. Criar usuário admin na tabela public.users
INSERT INTO public.users (id, email, full_name, role, is_active)
SELECT 
    id,
    email,
    raw_user_meta_data->>'full_name',
    'admin',
    true
FROM auth.users 
WHERE email = 'admin@chargeads.com';

-- 4. Criar perfil do admin
INSERT INTO public.user_profiles (user_id, company_name, phone, timezone)
SELECT 
    id,
    'ChargeADS',
    '(11) 99999-9999',
    'America/Sao_Paulo'
FROM public.users 
WHERE email = 'admin@chargeads.com';

-- 5. Verificar se foi criado
SELECT 
    u.id,
    u.email,
    u.full_name,
    u.role,
    u.is_active,
    up.company_name
FROM public.users u
LEFT JOIN public.user_profiles up ON u.id = up.user_id
WHERE u.email = 'admin@chargeads.com';
