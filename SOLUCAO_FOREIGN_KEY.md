# 🔧 Solução: Erro de Foreign Key ao Deletar Usuários

## ❌ Problema
```
Unable to delete rows as one of them is currently referenced by a foreign key constraint from the table audit_logs. Set an on delete behavior on the foreign key relation audit_logs_user_id_fkey in the audit_logs table to automatically respond when row(s) are being deleted in the users table.
```

## ✅ Solução Implementada

### 1. **Causa do Problema**
A tabela `audit_logs` tem uma foreign key para `users` sem especificar o comportamento de exclusão (`ON DELETE`). Isso impede a deleção de usuários que possuem logs de auditoria.

### 2. **Tabelas Afetadas**
- ✅ `audit_logs` → `user_id` (CASCADE - deleta logs quando usuário é deletado)
- ✅ `user_profiles` → `user_id` (CASCADE - deleta perfil quando usuário é deletado)  
- ✅ `players` → `created_by` (SET NULL - preserva player, remove referência)
- ✅ `media_files` → `uploaded_by` (SET NULL - preserva arquivo, remove referência)
- ✅ `playlists` → `created_by` (SET NULL - preserva playlist, remove referência)
- ✅ `schedules` → `created_by` (SET NULL - preserva agendamento, remove referência)

### 3. **Como Aplicar a Correção**

#### **Opção 1: Supabase Dashboard (Recomendado)**
1. Acesse seu projeto no [Supabase Dashboard](https://supabase.com/dashboard)
2. Vá para **SQL Editor**
3. Execute o SQL do arquivo `fix_user_deletion.sql`
4. Clique em **Run** para executar

#### **Opção 2: Via Migration**
```bash
# Se tiver Supabase CLI instalado
supabase db push
```

### 4. **SQL para Executar no Dashboard**

```sql
-- Fix the main culprit - audit_logs table
ALTER TABLE public.audit_logs DROP CONSTRAINT IF EXISTS audit_logs_user_id_fkey;
ALTER TABLE public.audit_logs 
ADD CONSTRAINT audit_logs_user_id_fkey 
FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

-- Fix user_profiles table
ALTER TABLE public.user_profiles DROP CONSTRAINT IF EXISTS user_profiles_user_id_fkey;
ALTER TABLE public.user_profiles 
ADD CONSTRAINT user_profiles_user_id_fkey 
FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

-- Fix players table
ALTER TABLE public.players DROP CONSTRAINT IF EXISTS players_created_by_fkey;
ALTER TABLE public.players 
ADD CONSTRAINT players_created_by_fkey 
FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

-- Fix media_files table
ALTER TABLE public.media_files DROP CONSTRAINT IF EXISTS media_files_uploaded_by_fkey;
ALTER TABLE public.media_files 
ADD CONSTRAINT media_files_uploaded_by_fkey 
FOREIGN KEY (uploaded_by) REFERENCES public.users(id) ON DELETE SET NULL;

-- Fix playlists table
ALTER TABLE public.playlists DROP CONSTRAINT IF EXISTS playlists_created_by_fkey;
ALTER TABLE public.playlists 
ADD CONSTRAINT playlists_created_by_fkey 
FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

-- Fix schedules table
ALTER TABLE public.schedules DROP CONSTRAINT IF EXISTS schedules_created_by_fkey;
ALTER TABLE public.schedules 
ADD CONSTRAINT schedules_created_by_fkey 
FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;
```

### 5. **Verificação**
Após executar o SQL:
1. ✅ Vá para **Table Editor** no Supabase
2. ✅ Selecione a tabela `users`
3. ✅ Tente deletar um usuário
4. ✅ Deve funcionar sem erros!

### 6. **Comportamentos Definidos**

| Tabela | Campo | Comportamento | Motivo |
|--------|-------|---------------|---------|
| `audit_logs` | `user_id` | `CASCADE` | Logs são específicos do usuário |
| `user_profiles` | `user_id` | `CASCADE` | Perfil pertence ao usuário |
| `players` | `created_by` | `SET NULL` | Preserva dados dos players |
| `media_files` | `uploaded_by` | `SET NULL` | Preserva arquivos de mídia |
| `playlists` | `created_by` | `SET NULL` | Preserva playlists |
| `schedules` | `created_by` | `SET NULL` | Preserva agendamentos |

### 7. **Arquivos Criados**
- ✅ `supabase/migrations/004_complete_foreign_key_fix.sql` - Migration completa
- ✅ `fix_user_deletion.sql` - SQL para executar no Dashboard
- ✅ `SOLUCAO_FOREIGN_KEY.md` - Esta documentação

### 8. **Para o Futuro**
- ✅ Problema resolvido permanentemente
- ✅ Novos usuários podem ser deletados sem problemas
- ✅ Dados importantes são preservados
- ✅ Sistema mantém integridade referencial

## 🎯 Resultado Final
**Agora você pode deletar usuários no Supabase Table Editor sem nenhum erro de foreign key!** 🚀

