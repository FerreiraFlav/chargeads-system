-- Script para criar usuário admin de teste
-- Email: admin@test.com
-- Senha: 123

-- Este script deve ser executado no SQL Editor do Supabase Dashboard
-- URL: https://supabase.com/dashboard/project/fpafzaxqvudzppabaqum/sql/new

-- IMPORTANTE: Este script só cria o registro na tabela public.users
-- Você DEVE criar o usuário no Supabase Auth primeiro através do Dashboard:
-- 1. Vá em Authentication -> Users
-- 2. Clique em "Add user" -> "Create new user"
-- 3. Email: admin@test.com
-- 4. Password: 123
-- 5. Marque: "Auto Confirm User" ✅
-- 6. Depois execute este SQL:

-- Verificar se o usuário já existe no auth.users
DO $$
DECLARE
    user_id UUID;
BEGIN
    -- Buscar o ID do usuário criado no auth.users
    SELECT id INTO user_id FROM auth.users WHERE email = 'admin@test.com';
    
    IF user_id IS NULL THEN
        RAISE NOTICE 'Usuário não encontrado no auth.users. Por favor, crie o usuário primeiro no Dashboard: Authentication -> Users -> Add user';
    ELSE
        -- Inserir ou atualizar na tabela public.users
        INSERT INTO public.users (id, email, full_name, role, is_active)
        VALUES (user_id, 'admin@test.com', 'Administrador', 'admin', true)
        ON CONFLICT (id) DO UPDATE 
        SET role = 'admin', full_name = 'Administrador', is_active = true;
        
        RAISE NOTICE 'Usuário admin@test.com configurado com sucesso como ADMIN!';
    END IF;
END $$;

-- Verificar o resultado
SELECT 
    u.id,
    u.email,
    u.full_name,
    u.role,
    u.is_active,
    au.email_confirmed_at
FROM public.users u
JOIN auth.users au ON u.id = au.id
WHERE u.email = 'admin@test.com';
