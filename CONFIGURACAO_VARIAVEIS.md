# 🔧 CONFIGURAÇÃO DE VARIÁVEIS DE AMBIENTE

## 📝 Criar arquivo `.env`

Crie um arquivo chamado `.env` na raiz do projeto com:

```env
VITE_SUPABASE_URL=sua_url_do_supabase_aqui
VITE_SUPABASE_ANON_KEY=sua_chave_anonima_do_supabase_aqui
```

## 🔍 Como encontrar suas credenciais:

### No Supabase Dashboard:
1. **Vá para**: https://supabase.com/dashboard
2. **Selecione seu projeto**
3. **Clique em "Settings"** (ícone de engrenagem)
4. **Clique em "API"**
5. **Copie**:
   - **Project URL** → `VITE_SUPABASE_URL`
   - **anon public** → `VITE_SUPABASE_ANON_KEY`

## ⚠️ IMPORTANTE:

- **NUNCA** commite o arquivo `.env` no GitHub
- **SEMPRE** use `.env.example` como template
- **Adicione** `.env` ao `.gitignore`

## 🚀 Para deploy online:

### Vercel/Netlify:
1. **No painel de deploy**, adicione as variáveis:
   - `VITE_SUPABASE_URL` = sua URL
   - `VITE_SUPABASE_ANON_KEY` = sua chave

### GitHub Pages:
- Use **GitHub Secrets** para variáveis sensíveis
