-- =============================================
-- CORRIGIR USUÁRIO DUPLICADO
-- =============================================
-- Execute este SQL no Supabase Dashboard

-- 1. Verificar se o usuário existe nas duas tabelas
SELECT 'auth.users' as tabela, id, email, email_confirmed_at 
FROM auth.users 
WHERE email = 'admin@chargeads.com'
UNION ALL
SELECT 'public.users' as tabela, id, email, created_at::text 
FROM public.users 
WHERE email = 'admin@chargeads.com';

-- 2. Se existir apenas em auth.users, criar na public.users
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
WHERE email = 'admin@chargeads.com'
AND id NOT IN (SELECT id FROM public.users WHERE email = 'admin@chargeads.com');

-- 3. Criar perfil se não existir
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
WHERE email = 'admin@chargeads.com'
AND id NOT IN (SELECT user_id FROM public.user_profiles WHERE user_id IN (
    SELECT id FROM public.users WHERE email = 'admin@chargeads.com'
));

-- 4. Verificar resultado final
SELECT 
    'Usuário corrigido com sucesso!' as status,
    u.email,
    u.full_name,
    u.role,
    u.is_active,
    CASE WHEN up.user_id IS NOT NULL THEN 'Perfil OK' ELSE 'Sem Perfil' END as perfil
FROM public.users u
LEFT JOIN public.user_profiles up ON u.id = up.user_id
WHERE u.email = 'admin@chargeads.com';
