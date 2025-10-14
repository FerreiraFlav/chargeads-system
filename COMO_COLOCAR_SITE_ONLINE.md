# 🌐 COMO COLOCAR SEU SITE ONLINE

## 🚀 Opções Gratuitas e Rápidas

### 1. **Vercel** (Mais Fácil - Recomendado)

#### ✅ Vantagens:
- **100% gratuito** para projetos pessoais
- **Deploy automático** do GitHub
- **HTTPS automático**
- **CDN global** (site rápido no mundo todo)
- **Domínio personalizado** gratuito

#### 📋 Como fazer:
1. **Crie conta** em: https://vercel.com
2. **Conecte seu GitHub** (se não tiver, crie uma conta)
3. **Suba seu código** para o GitHub:
   ```bash
   git init
   git add .
   git commit -m "Primeiro commit"
   git branch -M main
   git remote add origin https://github.com/seu-usuario/chargeads.git
   git push -u origin main
   ```
4. **Importe projeto** no Vercel
5. **Deploy automático** em 2 minutos!

---

### 2. **Netlify** (Também Muito Bom)

#### ✅ Vantagens:
- **Gratuito** até 100GB de banda
- **Deploy automático** do GitHub
- **Formulários** gratuitos
- **Funções serverless**

#### 📋 Como fazer:
1. **Acesse**: https://netlify.com
2. **Conecte GitHub** e selecione seu repositório
3. **Configure build**:
   - Build command: `npm run build`
   - Publish directory: `dist`
4. **Deploy** automático!

---

### 3. **GitHub Pages** (Gratuito)

#### ✅ Vantagens:
- **100% gratuito**
- **Integrado ao GitHub**
- **Domínio**: `seu-usuario.github.io/nome-do-propo`

#### 📋 Como fazer:
1. **No seu repositório GitHub**:
   - Vá em **Settings** → **Pages**
   - Source: **Deploy from a branch**
   - Branch: **gh-pages**
2. **Configure GitHub Actions** para build automático

---

## 🔧 Configurações Necessárias

### 1. **Ajustar URLs do Supabase**

Quando colocar online, você precisa atualizar as URLs permitidas no Supabase:

#### No Supabase Dashboard:
1. **Authentication** → **URL Configuration**
2. **Site URL**: `https://seu-site.vercel.app`
3. **Redirect URLs**: 
   - `https://seu-site.vercel.app/login`
   - `https://seu-site.vercel.app/dashboard`

### 2. **Variáveis de Ambiente**

Crie arquivo `.env` na raiz do projeto:
```env
VITE_SUPABASE_URL=sua_url_do_supabase
VITE_SUPABASE_ANON_KEY=sua_chave_anonima
```

### 3. **Atualizar vite.config.js**

```javascript
export default defineConfig({
  plugins: [vue()],
  base: '/', // ou '/nome-do-projeto/' se usar subdiretório
  server: {
    host: '0.0.0.0', // Permite acesso externo
    port: 3000
  }
})
```

---

## 🎯 **RECOMENDAÇÃO: VERCEL**

### Por que Vercel é a melhor opção:

1. **✅ Mais fácil** de usar
2. **✅ Deploy automático** do GitHub
3. **✅ HTTPS automático**
4. **✅ Domínio bonito**: `chargeads.vercel.app`
5. **✅ Performance excelente**
6. **✅ Suporte a Vue.js** nativo

### Passo a passo rápido:

1. **Crie conta no Vercel**
2. **Suba código para GitHub**
3. **Conecte GitHub ao Vercel**
4. **Deploy em 2 minutos!**

---

## 🔐 **Para Email Confirmation**

Com site online, você pode:
1. **Manter confirmação de email** ativada
2. **Usuários receberão email** de confirmação
3. **Link funcionará** porque site estará online

---

## 📱 **Acesso Mobile**

Com site online:
- ✅ **Funciona em qualquer dispositivo**
- ✅ **Acesso via celular/tablet**
- ✅ **Compartilhamento fácil**
- ✅ **Teste real** com outros usuários

---

## 🚀 **Próximos Passos**

1. **Escolha Vercel** (mais fácil)
2. **Suba código para GitHub**
3. **Configure deploy**
4. **Atualize URLs no Supabase**
5. **Teste site online!**

**Quer que eu te ajude com algum passo específico?** 🤖
