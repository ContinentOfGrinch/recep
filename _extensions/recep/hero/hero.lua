--[[
  recep · DynamicHero — küresel sayfa başlığı filtresi

  Her HTML sayfasının en üstüne, çerçevesiz bir "filigran" başlık alanı ekler:
    · arka planda sekmeye özgü Rönesans eseri (gri tonlu, çok düşük opaklık, ortalanmış)
    · önde Katman 1 dev başlık (Inter 900), altında Katman 2 açıklama (Lora)
  Eser, sayfanın bulunduğu klasörden (sekmeden) OTOMATİK seçilir; sayfalarda ek kod gerekmez.

  Front matter ile ayar (hepsi isteğe bağlı):
    title          → başlık            description → alt satır (Lora)
    hero: false    → bu sayfada kapat  hero-eser: athens|ambassadors|vitruvian|adam
    hero-baslik    → başlığı ez        hero-boyut: tam|buyuk|orta
]]

-- eser → dosya, odak noktası (object-position) ve künye
local ESER = {
  athens      = { dosya = "athens.webp",      odak = "50% 44%", kunye = "raphael — atina okulu, 1509–1511" },
  ambassadors = { dosya = "ambassadors.webp", odak = "50% 38%", kunye = "hans holbein (genç) — elçiler, 1533" },
  vitruvian   = { dosya = "vitruvian.webp",   odak = "50% 40%", kunye = "leonardo da vinci — vitruvius adamı, y. 1490" },
  adam        = { dosya = "adam.webp",        odak = "38% 46%", kunye = "michelangelo — adem'in yaratılışı, y. 1508–1512" },
}

-- sekme (klasör) → eser
local SEKME = {
  ana = "athens", ekip = "athens", ["404"] = "athens",
  haberler = "ambassadors", iletisim = "ambassadors",
  ["veri-kod"] = "vitruvian", araclar = "vitruvian",
  proje = "adam", ciktilar = "adam",
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

function Pandoc(doc)
  if not quarto.doc.is_format("html") then return nil end
  local m = doc.meta
  if m["hero"] == false or yazi(m["hero"]) == "false" then return nil end

  local sekme, dosya, derinlik, parcalar = konum()
  local eserAdi = yazi(m["hero-eser"]) or SEKME[sekme]
  if not eserAdi or not ESER[eserAdi] then return nil end
  local eser = ESER[eserAdi]

  local baslik = yazi(m["hero-baslik"]) or yazi(m["title"]) or yazi(m["pagetitle"]) or ""
  local alt = yazi(m["description"])

  local boyut = yazi(m["hero-boyut"])
  if not boyut then
    if sekme == "ana" then boyut = "tam"
    elseif dosya == "index" then boyut = "buyuk"
    else boyut = "orta" end
  end

  -- terminal yolu: /ekip · /proje/yontem
  local yol
  if sekme == "ana" then yol = "/"
  elseif dosya == "index" then yol = "/" .. sekme
  elseif derinlik == 0 then yol = "/" .. dosya
  else yol = "/" .. table.concat(parcalar, "/", 1, #parcalar - 1) .. "/" .. dosya end

  local ofset = derinlik == 0 and "." or string.rep("..", derinlik, "/")
  local src = ofset .. "/assets/sanat/" .. eser.dosya

  local html = string.format([[
<section class="recep-dhero recep-dhero--%s" data-eser="%s" aria-labelledby="recep-dhero-baslik">
  <div class="recep-dhero-sanat" aria-hidden="true"><img src="%s" alt="" style="object-position: %s" decoding="async" fetchpriority="high"></div>
  <div class="recep-dhero-icerik">
    <p class="recep-dhero-yol">%s</p>
    <h1 id="recep-dhero-baslik" class="recep-dhero-baslik">%s</h1>
    %s
  </div>
  <p class="recep-dhero-kunye">%s</p>
</section>]],
    boyut, eserAdi, src, eser.odak, kacis(yol), kacis(baslik),
    alt and ('<p class="recep-dhero-alt">' .. kacis(alt) .. '</p>') or "",
    kacis(eser.kunye))

  table.insert(doc.blocks, 1, pandoc.RawBlock("html", html))
  return doc
end
