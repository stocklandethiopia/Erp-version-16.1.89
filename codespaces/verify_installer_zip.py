#!/usr/bin/env python3
"""Exact Stockland ERP 16.2.18 installer ZIP verifier; never rebuilds the package."""
import hashlib, json, re, stat, sys, zipfile
from pathlib import Path, PurePosixPath
SHA="4a6bb09b4f5819873fff7f1417de20494c7d791003faf9a55649458458977021"
SIZE=2254042
SOURCE="fe937ea97123a243c410696e4007c48d3332803d"
ROOT="stockland-erp-app"
def fail(msg): raise SystemExit("FAIL exact 16.2.18 installer: "+msg)
p=Path(sys.argv[1]).resolve()
if not p.is_file(): fail("installer missing")
if p.stat().st_size!=SIZE or hashlib.sha256(p.read_bytes()).hexdigest()!=SHA: fail("exact byte-size/SHA-256 mismatch")
with zipfile.ZipFile(p) as z:
    if z.testzip() is not None: fail("ZIP CRC")
    infos=z.infolist(); names=[i.filename for i in infos]
    if len(names)!=len(set(names)): fail("duplicate ZIP member names")
    roots={PurePosixPath(n).parts[0] for n in names if n}
    if roots!={ROOT}: fail("unexpected archive root")
    data={}
    for i in infos:
        n=i.filename; q=PurePosixPath(n)
        if not n or "\\" in n or q.is_absolute() or any(x in ("",".","..") for x in q.parts): fail("unsafe path "+n)
        if stat.S_ISLNK((i.external_attr>>16)&0xffff): fail("symlink "+n)
        if not i.is_dir(): data[str(q.relative_to(ROOT))]=z.read(i)
try: m=json.loads(data["RELEASE_MANIFEST.json"])
except Exception as e: fail("missing/invalid manifest "+str(e))
if m.get("application",{}).get("version")!="16.2.18": fail("wrong application version")
if m.get("source_lineage",{}).get("canonical_source_commit")!=SOURCE: fail("wrong manifest source commit")
inventory=m.get("file_inventory",{})
listed=inventory.get("files")
if inventory.get("count")!=124 or not isinstance(listed,list): fail("wrong manifest file count")
expected={x["path"]:x["sha256"] for x in listed}
actual={n:hashlib.sha256(b).hexdigest() for n,b in data.items() if n!="RELEASE_MANIFEST.json"}
if len(actual)!=124 or actual!=expected: fail("per-file manifest digest mismatch")
entry=data.get("stockland-inventory.php",b"").decode()
header=re.search(r"^\s*\*\s*Version:\s*([0-9.]+)",entry,re.M)
constant=re.search(r"define\(\s*'STOCKLAND_VERSION'\s*,\s*'([0-9.]+)'",entry)
if not header or header.group(1)!="16.2.18" or not constant or constant.group(1)!="16.2.18": fail("plugin header/constant version mismatch")
print("PASS exact 16.2.18 installer SHA-256="+SHA+" bytes="+str(SIZE)+" manifest files=124")
