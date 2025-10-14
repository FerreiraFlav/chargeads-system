# Como Criar Usuário de Teste no Supabase

## Opção 1: Via Dashboard do Supabase (RECOMENDADO)

1. Acesse: https://supabase.com/dashboard/project/fpafzaxqvudzppabaqum/auth/users
2. Clique em "Add user" → "Create new user"
3. Preencha:
   - **Email**: `flaetrox@gmail.com`
   - **Password**: `123456`
   - **Auto Confirm User**: ✅ **MARQUE ESTA OPÇÃO**
4. Clique em "Create user"

## Opção 2: Desabilitar Confirmação de Email

1. Acesse: https://supabase.com/dashboard/project/fpafzaxqvudzppabaqum/auth/providers
2. Vá em **Email** provider
3. **Desabilite**: "Enable email confirmations"
4. Salve

Depois disso, você pode criar usuários normalmente pelo sistema.

## Opção 3: Usar Supabase CLI (para resetar senha)

```bash
# Instalar Supabase CLI
npm install -g supabase

# Login
supabase login

# Listar projetos
supabase projects list

# Resetar senha de um usuário
supabase db reset --password novo123456
```

## ✅ Após Criar o Usuário

1. No SQL Editor do Supabase, execute:

```sql
-- Promover usuário para admin
UPDATE public.users 
SET role = 'admin'
WHERE email = 'flaetrox@gmail.com';
```

2. Faça login no sistema com:
   - Email: `flaetrox@gmail.com`
   - Senha: `123456`

## 🔐 Credenciais de Teste Criadas

| Email | Senha | Role |
|-------|-------|------|
| admin@chargeads.com | 123456 | admin |
| flaetrox@gmail.com | 123456 | admin |

## 🚨 Importante

- Em produção, **SEMPRE** habilite a confirmação de email
- Use senhas fortes
- Configure SMTP para emails funcionarem corretamente

