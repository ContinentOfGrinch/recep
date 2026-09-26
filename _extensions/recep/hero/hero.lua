--[[
  recep · sayfa başlığı filtresi (DynamicHero)

  Her HTML sayfasının en üstüne otomatik bir başlık alanı ekler:
    · ana sayfa   → KÜRE HERO: ortada dönen wireframe dünya (assets/js/kure.js),
                    altında "recep" (Inter 900), grup adı (Lora), koordinat (Space Mono)
    · diğer sayfalar → ART CANVAS HERO: sütun genişliğinde, tam opak, 1-bit dither
                    Rönesans eseri; dev başlık (Inter 900) tuvalin SOL ALT köşesine
                    demirli, tuvalden taşarak zemine biner. Altında açıklama (Lora).
  Eser, sayfanın bulunduğu klasörden (sekmeden) OTOMATİK seçilir; sayfalarda ek kod gerekmez.

  Front matter ile ayar (hepsi isteğe bağlı):
    title          → başlık            description → alt satır (Lora)
    hero: false    → bu sayfada kapat  hero-eser: athens|ambassadors|elciler-tam|vitruvian|adam|syndics
    hero-baslik    → başlığı ez        hero-boyut: buyuk (16:9) | orta (21:9)
    hero-meta      → tuvalin üstündeki sol etiketi ez (Space Mono, neon; varsayılan: /yol)
]]

-- eser → dosya (1-bit PNG; w/h verilmezse 720×405), odak noktası ve künye.
-- tam = true: tablo KIRPILMADAN kendi oranında, en fazla w px genişlikte (dither 1:1; retinada 2×)
local ESER = {
  athens      = { dosya = "athens.png",      odak = "50% 50%", kunye = "raphael — atina okulu, 1509–1511" },
  ambassadors = { dosya = "ambassadors.png", odak = "50% 30%", kunye = "hans holbein (genç) — elçiler, 1533" },
  ["elciler-tam"] = { dosya = "ambassadors-tam.png", odak = "50% 50%", w = 704, h = 694, tam = true,
                  kunye = "hans holbein (genç) — elçiler, 1533 · tam tablo" },
  vitruvian   = { dosya = "vitruvian.png",   odak = "50% 30%", kunye = "leonardo da vinci — vitruvius adamı, y. 1490" },
  adam        = { dosya = "adam.png",        odak = "50% 42%", kunye = "michelangelo — adem'in yaratılışı, y. 1508–1512" },
  syndics     = { dosya = "syndics.png",     odak = "50% 50%", kunye = "rembrandt — kumaşçılar loncası yöneticileri, 1662" },
}

-- sekme (klasör) → eser
local SEKME = {
  ekip = "athens", ["404"] = "athens",
  haberler = "elciler-tam", iletisim = "ambassadors",
  ["veri-kod"] = "vitruvian", araclar = "vitruvian",
  proje = "adam", ciktilar = "adam",
  hakkimizda = "syndics",
}

local function kacis(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"))
end

local function yazi(v)
  if v == nil then return nil end
  local s = pandoc.utils.stringify(v)
  if s == "" then return nil end
  return s
end

-- proje köküne göre göreli yol: "ekip/index.qmd" → { "ekip", "index" }
local function konum()
  local girdi = (quarto.doc.input_file or ""):gsub("\\", "/")
  local kok = ((quarto.project and quarto.project.directory) or ""):gsub("\\", "/")
  local rel = girdi
  if kok ~= "" and girdi:sub(1, #kok) == kok then rel = girdi:sub(#kok + 2) end
  local parcalar = {}
  for p in rel:gmatch("[^/]+") do table.insert(parcalar, p) end
  local dosya = (parcalar[#parcalar] or ""):gsub("%.qmd$", ""):gsub("%.md$", "")
  local derinlik = #parcalar - 1
  local sekme
  if derinlik == 0 then
    sekme = (dosya == "index") and "ana" or dosya
  else
    sekme = parcalar[1]
  end
  return sekme, dosya, derinlik, parcalar
end

-- ana sayfa: ortada dönen küre
local function kureHero(baslik, alt)
  return string.format([[
<section class="recep-khero" aria-labelledby="recep-khero-baslik">
  <div class="recep-kure recep-khero-kure" data-hiz="0.006" role="presentation"></div>
  <h1 id="recep-khero-baslik" class="recep-khero-baslik">%s</h1>
  %s
  <p class="recep-khero-koord">lat 39.0 · lon 35.2 · <b>●</b> türkiye</p>
</section>]],
    kacis(baslik),
    alt and ('<p class="recep-khero-alt">' .. kacis(alt) .. '</p>') or "")
end

function Pandoc(doc)
  if not quarto.doc.is_format("html") then return nil end
  local m = doc.meta
  if m["hero"] == false or yazi(m["hero"]) == "false" then return nil end

  local sekme, dosya, derinlik, parcalar = konum()
  local baslik = yazi(m["hero-baslik"]) or yazi(m["title"]) or yazi(m["pagetitle"]) or ""
  local alt = yazi(m["description"])

  if sekme == "ana" and not yazi(m["hero-eser"]) then
    table.insert(doc.blocks, 1, pandoc.RawBlock("html", kureHero(baslik, alt)))
    return doc
  end

  local eserAdi = yazi(m["hero-eser"]) or SEKME[sekme]
  if not eserAdi or not ESER[eserAdi] then return nil end
  local eser = ESER[eserAdi]

  local boyut = yazi(m["hero-boyut"])
  if boyut ~= "buyuk" and boyut ~= "orta" then
    boyut = (dosya == "index") and "buyuk" or "orta"
  end

  -- yol: /ekip · /proje/yontem
  local yol
  if dosya == "index" then yol = "/" .. sekme
  elseif derinlik == 0 then yol = "/" .. dosya
  else yol = "/" .. table.concat(parcalar, "/", 1, #parcalar - 1) .. "/" .. dosya end

  local etiket = yazi(m["hero-meta"])
  local w, h = eser.w or 720, eser.h or 405
  local tamSinif, stil = "", ""
  if eser.tam then
    tamSinif = " recep-dhero--tam-eser"
    stil = string.format(' style="--tuval-oran: %d / %d; --tuval-max: %dpx"', w, h, w)
  end

  local ofset = derinlik == 0 and "." or string.rep("..", derinlik, "/")
  local src = ofset .. "/assets/sanat/" .. eser.dosya

  local html = string.format([[
<section class="recep-dhero recep-dhero--%s%s" data-eser="%s"%s aria-labelledby="recep-dhero-baslik">
  <div class="recep-dhero-meta%s"><span>%s</span><span>1-bit · %d×%d</span></div>
  <div class="recep-dhero-tuval">
    <img src="%s" alt="" width="%d" height="%d" style="object-position: %s" decoding="async" fetchpriority="high">
    <h1 id="recep-dhero-baslik" class="recep-dhero-baslik"><span>%s</span></h1>
  </div>
  <div class="recep-dhero-alt-satir">
    %s
    <p class="recep-dhero-kunye">%s</p>
  </div>
</section>]],
    boyut, tamSinif, eserAdi, stil, etiket and " recep-dhero-meta--etiket" or "", kacis(etiket or yol), w, h, src, w, h, eser.odak, kacis(baslik),
    alt and ('<p class="recep-dhero-alt">' .. kacis(alt) .. '</p>') or "",
    kacis(eser.kunye))

  table.insert(doc.blocks, 1, pandoc.RawBlock("html", html))
  return doc
end
