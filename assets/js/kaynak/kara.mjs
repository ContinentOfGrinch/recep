// world-atlas land-110m TopoJSON → [[lon,lat,lon,lat,...], ...] halkaları (0.1° hassasiyet)
import fs from "node:fs";
const [src, out] = process.argv.slice(2);
const topo = JSON.parse(fs.readFileSync(src, "utf8"));
const { scale: [sx, sy], translate: [tx, ty] } = topo.transform;

// delta kodlu arkları mutlak koordinatlara çevir
const arcs = topo.arcs.map(arc => {
  let x = 0, y = 0;
  return arc.map(([dx, dy]) => { x += dx; y += dy; return [x * sx + tx, y * sy + ty]; });
});
const arcPts = i => (i >= 0 ? arcs[i] : arcs[~i].slice().reverse());

const rings = [];
for (const geom of topo.objects.land.geometries) {
  const polys = geom.type === "Polygon" ? [geom.arcs] : geom.arcs;
  for (const poly of polys) for (const ring of poly) {
    const pts = [];
    for (const a of ring) { const p = arcPts(a); pts.push(...(pts.length ? p.slice(1) : p)); }
    // 0.1° yuvarla, ardışık tekrarları at
    const flat = []; let px, py;
    for (const [lon, lat] of pts) {
      const x = Math.round(lon * 10) / 10, y = Math.round(lat * 10) / 10;
      if (x !== px || y !== py) { flat.push(x, y); px = x; py = y; }
    }
    if (flat.length >= 8) rings.push(flat);
  }
}
fs.writeFileSync(out, JSON.stringify(rings));
console.log("halka:", rings.length, "nokta:", rings.reduce((s, r) => s + r.length / 2, 0), "bayt:", fs.statSync(out).size);
