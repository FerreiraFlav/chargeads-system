-- =============================================
-- CONFIGURAR AUTENTICAÇÃO PARA DESENVOLVIMENTO
-- =============================================
-- Execute este SQL no Supabase Dashboard

-- 1. Verificar configurações atuais de autenticação
SELECT * FROM auth.config;

-- 2. Atualizar configurações para desenvolvimento local
UPDATE auth.config SET 
    raw_user_meta_data = jsonb_set(
        COALESCE(raw_user_meta_data, '{}'), 
        '{email_confirm_url}', 
        '"http://localhost:3003/login"'
    );

-- 3. Verificar se foi atualizado
SELECT * FROM auth.config;
