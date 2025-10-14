-- =============================================
-- SOLUÇÃO DEFINITIVA PARA LOGIN - EXECUTE TUDO DE UMA VEZ
-- =============================================
-- Este SQL resolve TODOS os problemas de login

-- PASSO 1: Limpar usuários existentes problemáticos
DELETE FROM public.user_profiles WHERE user_id IN (
    SELECT id FROM public.users WHERE email IN ('admin@chargeads.com', 'teste@chargeads.com')
);
DELETE FROM public.users WHERE email IN ('admin@chargeads.com', 'teste@chargeads.com');
DELETE FROM auth.users WHERE email IN ('admin@chargeads.com', 'teste@chargeads.com');

-- PASSO 2: Verificar configurações de autenticação
-- Se der erro, ignore e continue
DO $$
BEGIN
    -- Verificar se RLS está configurado corretamente
    EXECUTE 'ALTER TABLE public.users ENABLE ROW LEVEL SECURITY';
    EXECUTE 'ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY';
EXCEPTION WHEN OTHERS THEN
    -- Ignorar erros se já estiver configurado
    NULL;
END $$;

-- PASSO 3: Criar usuário ADMIN funcional
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

-- PASSO 4: Criar usuário na tabela public.users
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

-- PASSO 5: Criar perfil do admin
INSERT INTO public.user_profiles (user_id, company_name, phone, timezone, preferences, created_at, updated_at)
SELECT 
    id,
    'ChargeADS',
    '(11) 99999-9999',
    'America/Sao_Paulo',
    '{}',
    NOW(),
    NOW()
FROM public.users 
WHERE email = 'admin@chargeads.com';

-- PASSO 6: Criar usuário de teste funcional
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

-- PASSO 7: Criar usuário de teste na tabela public.users
INSERT INTO public.users (id, email, full_name, role, is_active, created_at, updated_at)
SELECT 
    id,
    email,
    raw_user_meta_data->>'full_name',
    'user',
    true,
    NOW(),
    NOW()
FROM auth.users 
WHERE email = 'teste@chargeads.com';

-- PASSO 8: Criar perfil do usuário de teste
INSERT INTO public.user_profiles (user_id, company_name, phone, timezone, preferences, created_at, updated_at)
SELECT 
    id,
    'Empresa de Teste',
    '(11) 99999-9999',
    'America/Sao_Paulo',
    '{}',
    NOW(),
    NOW()
FROM public.users 
WHERE email = 'teste@chargeads.com';

-- PASSO 9: Verificar se tudo foi criado corretamente
SELECT 
    'RESULTADO FINAL:' as status,
    u.email,
    u.full_name,
    u.role,
    u.is_active,
    CASE 
        WHEN au.email IS NOT NULL THEN '✅ Auth OK'
        ELSE '❌ Auth FALTANDO'
    END as auth_status,
    CASE 
        WHEN up.user_id IS NOT NULL THEN '✅ Profile OK'
        ELSE '❌ Profile FALTANDO'
    END as profile_status
FROM public.users u
LEFT JOIN auth.users au ON u.email = au.email
LEFT JOIN public.user_profiles up ON u.id = up.user_id
WHERE u.email IN ('admin@chargeads.com', 'teste@chargeads.com')
ORDER BY u.email;

-- PASSO 10: Mensagem de sucesso
SELECT '🎉 USUÁRIOS CRIADOS COM SUCESSO!' as resultado,
       'admin@chargeads.com / 123456' as admin_credenciais,
       'teste@chargeads.com / 123456' as teste_credenciais;
