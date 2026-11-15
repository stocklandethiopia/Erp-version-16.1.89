#!/usr/bin/env python3
from pathlib import Path, PurePosixPath
import hashlib, json, re, stat, sys, zipfile
SHA='30b3f629e8303d0b30981f311f2f4d32499b012f21e1f44c7f237919aafc9916'
SIZE=2254041
MANIFEST_SOURCE='83a43bc0543ae45bfa9bdab52bbcd5c07b61aeb4'
ROOT='stockland-erp-app'
path=Path(sys.argv[1]).resolve()
def fail(message): raise SystemExit('FAIL: '+message)
if not path.is_file(): fail('installer missing')
actual=hashlib.sha256(path.read_bytes()).hexdigest()
if path.stat().st_size!=SIZE or actual!=SHA: fail(f'exact hash/size mismatch: {actual} / {path.stat().st_size}')
with zipfile.ZipFile(path) as archive:
    if archive.testzip() is not None: fail('ZIP CRC failure')
    entries=archive.infolist()
    names=[item.filename for item in entries]
    if len(names)!=len(set(names)): fail('duplicate ZIP member names')
    roots={PurePosixPath(name).parts[0] for name in names if name}
    if roots!={ROOT}: fail(f'unexpected root: {roots}')
    data={}
    for item in entries:
        name=item.filename
        rel=PurePosixPath(name)
        if not name or '\\' in name or rel.is_absolute() or any(part in ('','.','..') for part in rel.parts): fail('unsafe path '+name)
        if stat.S_ISLNK((item.external_attr>>16)&0xffff): fail('symlink member '+name)
        if not item.is_dir(): data[str(rel.relative_to(ROOT))]=archive.read(item)
    manifest=json.loads(data['RELEASE_MANIFEST.json'])
    if manifest.get('application',{}).get('version')!='16.2.18': fail('application version')
    if manifest.get('source_lineage',{}).get('canonical_source_commit')!=MANIFEST_SOURCE: fail('manifest source commit')
    inventory=manifest.get('file_inventory',{})
    if inventory.get('count')!=124 or not isinstance(inventory.get('files'),list): fail('manifest inventory')
    expected={record['path']:record['sha256'] for record in inventory['files']}
    observed={name:hashlib.sha256(value).hexdigest() for name,value in data.items() if name!='RELEASE_MANIFEST.json'}
    if observed!=expected: fail('per-file manifest checksum mismatch')
    entry=data.get('stockland-inventory.php',b'').decode('utf-8')
    if not re.search(r'Version:\\s*16\.2\.18',entry): fail('plugin header version')
print(f'PASS exact installer sha256={actual} bytes={path.stat().st_size} manifest_files=124')
