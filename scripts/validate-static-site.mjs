import fs from "node:fs";
import path from "node:path";

const root = process.cwd();
const errors = [];
const warnings = [];
const externalSchemes = /^(https?:|mailto:|tel:|data:|blob:|javascript:|#)/i;

function fail(message) {
  errors.push(message);
}

function warn(message) {
  warnings.push(message);
}

function read(file) {
  return fs.readFileSync(path.join(root, file), "utf8");
}

function exists(file) {
  return fs.existsSync(path.join(root, file));
}

function walk(dir, predicate, out = []) {
  const fullDir = path.join(root, dir);
  if (!fs.existsSync(fullDir)) return out;
  for (const entry of fs.readdirSync(fullDir, { withFileTypes: true })) {
    const rel = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      walk(rel, predicate, out);
    } else if (predicate(rel)) {
      out.push(rel);
    }
  }
  return out;
}

function stripHashAndQuery(value) {
  return value.split("#")[0].split("?")[0];
}

function resolveLocalReference(fromFile, ref) {
  const clean = stripHashAndQuery(ref);
  if (!clean || externalSchemes.test(ref)) return null;
  const base = path.dirname(fromFile);
  return path.normalize(path.join(base, clean));
}

function getAttributes(html, attrName) {
  const values = [];
  const regex = new RegExp(`${attrName}\\s*=\\s*["']([^"']+)["']`, "gi");
  let match;
  while ((match = regex.exec(html)) !== null) {
    values.push(match[1]);
  }
  return values;
}

function checkRequiredFile(file) {
  if (!exists(file)) fail(`Missing required file: ${file}`);
}

checkRequiredFile("index.html");
checkRequiredFile("robots.txt");
checkRequiredFile("sitemap.xml");

const htmlFiles = walk(".", (rel) => rel.endsWith(".html"));

if (htmlFiles.length === 0) {
  fail("No HTML files found.");
}

for (const file of htmlFiles) {
  const html = read(file);

  const titleMatches = html.match(/<title\b[^>]*>[\s\S]*?<\/title>/gi) || [];
  if (titleMatches.length !== 1) {
    fail(`${file}: expected exactly one <title>, found ${titleMatches.length}`);
  }

  if (!/<meta\s+name=["']description["']/i.test(html)) {
    warn(`${file}: missing meta description`);
  }

  if (!/<meta\s+name=["']viewport["']/i.test(html)) {
    fail(`${file}: missing viewport meta tag`);
  }

  if (file === "index.html") {
    if (!/<script\s+type=["']application\/ld\+json["']/i.test(html)) {
      fail("index.html: missing Person structured data JSON-LD");
    }
    if (!/<link\s+rel=["']canonical["']\s+href=["']https:\/\/nempickaxe\.github\.io\/["']/i.test(html)) {
      fail("index.html: missing canonical link for homepage");
    }
  }

  if (file === path.normalize("work/gail.html")) {
    const requiredSnippets = [
      "Google Cloud Generative AI Leader",
      "https://nempickaxe.github.io/work/gail.html",
      "https://nempickaxe.github.io/work/images/gail-concept-map.png",
      "application/ld+json"
    ];
    for (const snippet of requiredSnippets) {
      if (!html.includes(snippet)) {
        fail(`${file}: missing required SEO/content snippet: ${snippet}`);
      }
    }
  }

  for (const href of getAttributes(html, "href")) {
    const target = resolveLocalReference(file, href);
    if (target && !exists(target)) {
      fail(`${file}: broken local href "${href}" -> ${target}`);
    }
  }

  for (const src of getAttributes(html, "src")) {
    const target = resolveLocalReference(file, src);
    if (target && !exists(target)) {
      fail(`${file}: broken local src "${src}" -> ${target}`);
    }
  }
}

if (exists("robots.txt")) {
  const robots = read("robots.txt");
  if (!robots.includes("Sitemap: https://nempickaxe.github.io/sitemap.xml")) {
    fail("robots.txt: missing sitemap directive");
  }
}

if (exists("sitemap.xml")) {
  const sitemap = read("sitemap.xml");
  if (!sitemap.includes("<urlset")) {
    fail("sitemap.xml: missing <urlset>");
  }

  const locs = [...sitemap.matchAll(/<loc>([^<]+)<\/loc>/g)].map((m) => m[1]);
  if (locs.length === 0) {
    fail("sitemap.xml: no <loc> entries found");
  }

  for (const loc of locs) {
    if (!loc.startsWith("https://nempickaxe.github.io/")) {
      fail(`sitemap.xml: unexpected non-site URL: ${loc}`);
    }
  }
}

for (const warning of warnings) {
  console.warn(`Warning: ${warning}`);
}

if (errors.length > 0) {
  console.error("\nStatic site validation failed:");
  for (const error of errors) {
    console.error(`- ${error}`);
  }
  process.exit(1);
}

console.log(`Static site validation passed for ${htmlFiles.length} HTML file(s).`);
