# RECEP web sitesi — proje hafızası

> Her oturumun başında bu dosya okunur. Her önemli karar ve tamamlanan aşamadan sonra güncellenir.
> Son güncelleme: 2026-09-23 (oturum 1, 2. aşama)

## 1. proje künyesi
- **Ne:** RECEP araştırma grubunun web sitesi (iklim ekonomisi, CBAM, dinamik panel / Sistem GMM).
- **Bütçe:** 0 TL. Yalnızca açık kaynak + GitHub Pages + GitHub Actions.
- **Sahiplik:** Kod önce kullanıcının kişisel GitHub hesabına → sonra Doç. Dr. Tunç Durmaz'a veya lab organizasyonuna devredilecek (adımlar README'de).
- **Yığın:** Quarto **1.10.18** (yerel = CI, sabitlendi), R 4.5.1 (`plm`, `renv`, `ggplot2` yerelde kurulu), SCSS/Bootstrap 5.
- **Yerel yol:** `C:\Users\selah\Desktop\RECEP\recep_internet_sitesi`
- **GitHub:** repo **https://github.com/ContinentOfGrinch/recep** (public, `main`). Canlı site: **https://continentofgrinch.github.io/recep/**. Pages kaynağı: GitHub Actions (API ile ayarlandı).
- **Araçlar:** `gh` CLI yüklü değil; GitHub API çağrıları git credential manager token'ı ile (`git credential fill`) curl üzerinden yapılıyor (scope: repo, workflow, gist). JSON gövdesinde Türkçe karakter varsa `--data-binary @dosya.json` kullan (satır içi `-d` bozuluyor).

## 2. tasarım manifestosu (değişmez)
- Estetik: Apple / Vercel / Quarto docs — steril, teknolojik. 90'lar üniversite sitesi YOK.
- Fontlar: gövde **Inter**, kod **JetBrains Mono**, başlık + logo **Roboto Condensed Bold**.
- Tüm başlıklar **küçük harf** (CSS `text-transform: lowercase`; `lang="tr"` ile I→ı doğru). Kaynakta da küçük harf yazılır.
- Logo: `recep` → CSS `::before/::after` ile **[recep]**, parantezler vurgu renginde.
- Navbar: beyaz, sabit, ince alt çizgi + blur; arama (overlay) + tema düğmesi + GitHub + RSS.
- Dil: `lang: tr`, içerik Türkçe.

## 3. mimari kararlar
| konu | karar |
|---|---|
| Fontlar | **Kendi sunucumuzda** (`assets/fonts/*.woff2`, fontsource kaynaklı, OFL lisansları yanında). `assets/fonts.css` → `format.html.css`. latin + latin-ext alt kümeleri, unicode-range ile (ı latin'de; ğ ş İ latin-ext'te). Toplam ~228 KB, değişken fontlar. Google'a istek yok (hız + KVKK). |
| Tema | `theme.scss` (palet `$recep-*` + tüm kurallar), `theme-dark.scss` (yalnızca palet). dark = `[theme.scss, theme-dark.scss]`. `respect-user-color-scheme: true`. Hiçbir yerde sabit renk yok, hep `$recep-*`. |
| Palet | açık: ink #0a0a0a, paper #fff, muted #666, line #eaeaea, surface #fafafa, accent #0f766e · koyu: ink #ededed, paper #0a0a0a, muted #a1a1a1, line #262626, surface #141414, accent #2dd4bf |
| Ana sayfa | `index.qmd`, `page-layout: full`, hero + `.recep-grid` 3 sütun (<992px tek sütun). |
| Sidebar | İki sidebar id: `projeler`, `dokumantasyon`; içerik `- auto: <klasör>` (tek seviye, `order` alanına göre sıralı). **Glob/section denemeleri çift başlık üretti — auto kullan.** |
| Liste sayfaları | `projeler/index.qmd` (default listing), `dokumantasyon/index.qmd` (table listing, `order`'a göre). `contents: "*.qmd"` (index kendini otomatik hariç tutar; `!(index)` glob'u listing'de ÇALIŞMAZ). |
| Blog | `blog/index.qmd` grid listing, 3 sütun, kategori + filtre + RSS (`blog/index.xml`). Yazılar `blog/posts/YYYY-AA-GG-slug/index.qmd`. `blog/posts/_metadata.yml`: `freeze: true`, `citation: true`, yazar varsayılanı. |
| Ekip / Yayınlar | **Veri odaklı:** `data/ekip.yml`, `data/yayinlar.yml` → özel EJS şablonları `_templates/ekip.ejs`, `_templates/yayinlar.ejs`. Ekip rol gruplu (yurutucu/arastirmaci/asistan/mezun, `sira`), foto yoksa baş harf avatarı. Yayınlar yıla göre gruplu, tür etiketi, doi/pdf/kod linkleri. |
| EJS tuzakları | (1) Listing verisi `_` ile başlayan klasörde OLAMAZ (bulunmaz) → `data/`. (2) EJS çıktısı markdown olarak işlenir → şablonlar ```` ```{=html} ```` bloğu içine sarıldı. |
| R / freeze | Global `freeze: auto`. R içeren sayfa yerelde render edilir, `_freeze/` commit edilir, CI'da R yok. Örnek: `dokumantasyon/sistem-gmm-ornegi.qmd` (plm `pgmm`, `transformation="ld"`, EmplUK) — çalışıyor, donduruldu. |
| Klasör varsayılanları | `projeler/_metadata.yml`, `dokumantasyon/_metadata.yml` (code-tools), `blog/posts/_metadata.yml`. |
| İçerik şablonları | `_sablonlar/` (render edilmez): `blog-yazisi.qmd` (draft: true), `proje.qmd`, `rehber.qmd`. |
| 404 | `404.qmd`; Quarto `site-url`'den mutlak yol (`/recep/...`) üretir → **site-url doğru olmalı**. CI link kontrolünden hariç. |
| SEO | `open-graph`, `twitter-card`, `website.image: assets/og.png` (1200×630, headless Edge ile kendi fontlarımızla üretildi; kaynak HTML yeniden üretilebilir). sitemap/robots otomatik. |
| Render kapsamı | `project.render` yalnızca `.qmd` → `memory.md`, `README.md` siteye girmez. |
| CI/CD | `.github/workflows/publish.yml`: push(main)/PR/manuel → Quarto 1.10.18 render → lychee offline iç link kontrolü (404 hariç) → yalnızca main'de `upload-pages-artifact` + `deploy-pages`. gh-pages dalı YOK (Pages kaynağı "GitHub Actions"). `dependabot.yml` Actions sürümlerini aylık günceller. |
| Repo hijyeni | `.editorconfig` (utf-8, lf, 2 boşluk), `.gitattributes` (`eol=lf`, woff2/png binary), `.gitignore` (`_site/`, `.quarto/`, R dosyaları), `LICENSE` (MIT kod; içerik CC BY 4.0 footer'da). |
| Erişilebilirlik | `:focus-visible` halkası, `prefers-reduced-motion`, ikon linklerde aria-label. |

## 4. dosya haritası
```
_quarto.yml / theme.scss / theme-dark.scss
assets/        fonts.css, fonts/ (woff2 + OFL), favicon.svg, og.png
data/          ekip.yml, yayinlar.yml
_templates/    ekip.ejs, yayinlar.ejs
_sablonlar/    blog-yazisi.qmd, proje.qmd, rehber.qmd
_freeze/       dondurulmuş R çıktıları (commit edilir)
index.qmd, ekip.qmd, yayinlar.qmd, 404.qmd
projeler/      index.qmd (listing), cbam-turkiye.qmd, _metadata.yml
dokumantasyon/ index.qmd (listing), kurulum.qmd, sistem-gmm-ornegi.qmd, _metadata.yml
blog/          index.qmd (listing), posts/_metadata.yml, posts/2026-09-23-merhaba/
.github/       workflows/publish.yml, dependabot.yml
README.md, LICENSE, .editorconfig, .gitattributes, .gitignore, .nojekyll
```

## 5. doğrulama yöntemi (tekrar kullanılabilir)
- Tam derleme: `rm -rf _site && quarto render` → uyarısız olmalı.
- Ekran görüntüsü: headless Edge, **her çağrıda ayrı `--user-data-dir`** (yoksa ilk görüntüyü tekrar yazar). `--blink-settings=preferredColorScheme=1` açık, `=0` koyu. Headless minimum genişlik ~481px (390 verilince kırpılır; taşma değildir — `scrollWidth==clientWidth` ile doğrulandı).
- Bash'te `python` ÇAĞIRMA (Windows Store takma adı, takılıyor).

## 6. tamamlanan aşamalar
- [x] 2026-09-23 — Aşama 1: manifesto onayı, iskelet, ilk render.
- [x] 2026-09-23 — Aşama 2 (altyapı sağlamlaştırma): self-host fontlar, veri odaklı ekip/yayınlar, liste sayfaları, klasör varsayılanları, içerik şablonları, 404, R/freeze hattı (Sistem GMM örneği), OG görseli, CI (PR kontrolü + link kontrolü + sürüm sabitleme), dependabot, README/LICENSE/editorconfig/gitattributes, git init. Açık/koyu/mobil ekran görüntüleriyle görsel kontrol yapıldı; bulunan sorunlar (sidebar çift başlık, koyu temada input zemini, kategori büyük harf, footer çizgisi) düzeltildi.

## 7. açık işler / TODO
- [x] Yer tutucular dolduruldu (ContinentOfGrinch / recep). Repo adı değişirse `site-url` + 404 yolları da değişir.
- [x] 2026-09-23 repo oluşturuldu (açıklama + topic'ler), Pages = Actions, ilk commit + push.
- [ ] İlk Actions çalışmasının sonucunu ve canlı siteyi doğrula.
- [ ] Gerçek içerik: ekip (`data/ekip.yml`), yayınlar, proje sayfaları, blog yazıları.
- [ ] Kalıcı logo/favicon tasarımı (şu an geçici `[r]` SVG).
- [ ] R içeriği büyüdüğünde `renv` ile paket sürümlerini kilitle (şimdilik ertelendi; CI R kullanmadığı için acil değil).
- [ ] İsteğe bağlı: iletişim bilgisi / e-posta, analitik (çerezsiz, ör. GoatCounter) kararı.

## 8. sıradaki adım
Actions çalışması yeşilse canlı sitede görsel kontrol; kırmızıysa log'u incele. Ardından gerçek içerik girişi: ekip, yayınlar, projeler, blog.
