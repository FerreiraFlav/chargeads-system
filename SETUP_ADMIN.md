# 🔐 Como Criar o Usuário Admin - PASSO A PASSO

## ⚠️ IMPORTANTE
O Supabase Auth gerencia senhas de forma segura e **NÃO permite** criar/alterar senhas diretamente no banco de dados. Você **DEVE** criar o usuário através do Dashboard do Supabase.

---

## 📝 PASSOS PARA CRIAR USUÁRIO ADMIN

### **Passo 1: Acesse o Dashboard do Supabase**
🔗 **Link direto:** https://supabase.com/dashboard/project/fpafzaxqvudzppabaqum/auth/users

### **Passo 2: Crie o Usuário**
1. Clique no botão verde **"Add user"** no canto superior direito
2. Selecione **"Create new user"**
3. Preencha o formulário:
   ```
   📧 Email: admin@test.com
   🔒 Password: 123
   ✅ Auto Confirm User: MARQUE ESTA OPÇÃO!
   ```
4. Clique em **"Create user"**

### **Passo 3: Promover para Admin**
1. Ainda no Dashboard do Supabase, vá em **SQL Editor**
   🔗 https://supabase.com/dashboard/project/fpafzaxqvudzppabaqum/sql/new

2. Cole e execute este SQL:
   ```sql
   -- Promover usuário para admin
   UPDATE public.users 
   SET role = 'admin', full_name = 'Administrador'
   WHERE email = 'admin@test.com';
   
   -- Verificar
   SELECT id, email, full_name, role, is_active 
   FROM public.users 
   WHERE email = 'admin@test.com';
   ```

### **Passo 4: Fazer Login no Sistema**
1. Acesse: http://localhost:3003
2. Use as credenciais:
   ```
   📧 Email: admin@test.com
   🔒 Senha: 123
   ```
3. Clique em **"Entrar"**

---

## ✅ CREDENCIAIS DE ACESSO

| Email | Senha | Role | Status |
|-------|-------|------|--------|
| admin@test.com | 123 | admin | ✅ Use esta |
| flaetrox@gmail.com | 123456 | admin | ⚠️ Requer reset de senha |
| admin@chargeads.com | 123456 | admin | ⚠️ Requer reset de senha |

---

## 🔧 ALTERNATIVA: Configurar para Desenvolvimento

Se quiser evitar confirmação de email em desenvolvimento:

### **No Dashboard do Supabase:**
1. Vá em: **Authentication** → **Providers** → **Email**
   🔗 https://supabase.com/dashboard/project/fpafzaxqvudzppabaqum/auth/providers

2. **Desabilite:**
   - ❌ "Enable email confirmations"

3. **Salve** as alterações

4. Agora você pode criar usuários pelo próprio sistema sem precisar confirmar email!

---

## 🚨 Troubleshooting

### Erro: "Invalid login credentials"
**Causa:** Usuário não existe ou senha incorreta no Supabase Auth

**Solução:**
1. Verifique se criou o usuário no Dashboard (não no SQL!)
2. Marque "Auto Confirm User" ao criar
3. Use a senha exata que definiu (case-sensitive)

### Erro: "Email not confirmed"
**Causa:** Email não foi confirmado

**Solução:**
1. Execute no SQL Editor:
   ```sql
   UPDATE auth.users 
   SET email_confirmed_at = NOW()
   WHERE email = 'seu-email@test.com';
   ```

### Botão fica "Carregando..."
**Causa:** Erro de autenticação não tratado

**Solução:**
1. Abra o DevTools (F12)
2. Veja o erro no Console
3. Verifique se as credenciais estão corretas

---

## 📞 Links Úteis

- **Supabase Dashboard**: https://supabase.com/dashboard/project/fpafzaxqvudzppabaqum
- **Auth Users**: https://supabase.com/dashboard/project/fpafzaxqvudzppabaqum/auth/users
- **SQL Editor**: https://supabase.com/dashboard/project/fpafzaxqvudzppabaqum/sql/new
- **Auth Settings**: https://supabase.com/dashboard/project/fpafzaxqvudzppabaqum/auth/providers

---

## ✨ Após o Login Funcionar

Você terá acesso a:
- 📊 Dashboard com indicadores em tempo real
- 🖥️ Gestão de players (monitores)
- 📅 Programações e agendamentos
- 📁 Upload de mídias
- ⚙️ Configurações do sistema
- 👥 Gestão de usuários (admin)

