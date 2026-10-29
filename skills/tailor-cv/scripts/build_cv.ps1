<#
Builds an ATS-safe CV (.docx + .pdf) from a content JSON, on top of the base template's styles.

  build_cv.ps1 -Content <content.json> -OutDir <cv output\YYYY.MM.DD Role - Company> -BaseName <First_Last_Role_Resume>
               [-Template <base.docx>] [-WorkDir <scratch dir>]

Output: <OutDir>\<BaseName>.docx and .pdf, plus <WorkDir>\raw.txt (ATS text extraction)
and <WorkDir>\page-N.png previews. Prints page count and any "banned" terms found.
Requires: Microsoft Word (COM) for the PDF; Poppler (winget: oschwartz10612.Poppler) for checks.
#>
param(
  [Parameter(Mandatory)][string]$Content,
  [Parameter(Mandatory)][string]$OutDir,
  [Parameter(Mandatory)][string]$BaseName,
  [string]$Template = (Join-Path $PSScriptRoot '..\assets\base_template.docx'),
  [string]$WorkDir = (Join-Path $env:TEMP ('cvbuild_' + [guid]::NewGuid().ToString('N').Substring(0, 8)))
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$utf8 = New-Object System.Text.UTF8Encoding($false)
function ReadU($p) { [IO.File]::ReadAllText($p, $utf8) }
function WriteU($p, $t) { [IO.File]::WriteAllText($p, $t, $utf8) }
function X([string]$s) { [System.Security.SecurityElement]::Escape($s) }

$c = ReadU $Content | ConvertFrom-Json
New-Item -ItemType Directory -Force $WorkDir | Out-Null
$unpacked = Join-Path $WorkDir 'unpacked'
if (Test-Path $unpacked) { Remove-Item $unpacked -Recurse -Force }
[System.IO.Compression.ZipFile]::ExtractToDirectory((Resolve-Path $Template).Path, $unpacked)

# ---------- paragraph templates (formatting copied from the 2026.08.29 CV) ----------
$F = '<w:rFonts w:ascii="Lato" w:hAnsi="Lato"/>'
$P20 = "<w:rPr>$F<w:sz w:val=`"20`"/><w:szCs w:val=`"24`"/></w:rPr>"
function Heading($t) { "<w:p><w:pPr><w:keepNext/><w:pBdr><w:bottom w:val=`"single`" w:sz=`"6`" w:space=`"1`" w:color=`"B7C9DB`"/></w:pBdr><w:spacing w:before=`"90`" w:after=`"44`"/>$P20</w:pPr><w:r><w:rPr>$F<w:b/><w:color w:val=`"1F4E79`"/><w:sz w:val=`"22`"/><w:szCs w:val=`"24`"/></w:rPr><w:t>$(X $t)</w:t></w:r></w:p>" }
function Summary($t) { "<w:p><w:pPr><w:spacing w:after=`"50`" w:line=`"240`" w:lineRule=`"auto`"/><w:jc w:val=`"both`"/>$P20</w:pPr><w:r><w:rPr>$F<w:color w:val=`"232323`"/><w:sz w:val=`"20`"/><w:szCs w:val=`"24`"/></w:rPr><w:t xml:space=`"preserve`">$(X $t)</w:t></w:r></w:p>" }
function SkillLine($label, $t) { "<w:p><w:pPr><w:pStyle w:val=`"ListParagraph`"/><w:keepNext/><w:numPr><w:ilvl w:val=`"0`"/><w:numId w:val=`"18`"/></w:numPr><w:spacing w:before=`"20`" w:after=`"20`"/>$P20</w:pPr><w:r><w:rPr>$F<w:b/><w:color w:val=`"1F4E79`"/><w:sz w:val=`"20`"/><w:szCs w:val=`"24`"/></w:rPr><w:t xml:space=`"preserve`">$(X $label): </w:t></w:r><w:r>$P20<w:t>$(X $t)</w:t></w:r></w:p>" }
function JobTitle($t) { "<w:p><w:pPr><w:keepNext/><w:spacing w:before=`"70`" w:after=`"0`"/>$P20</w:pPr><w:r><w:rPr>$F<w:b/><w:color w:val=`"232323`"/><w:sz w:val=`"22`"/><w:szCs w:val=`"24`"/></w:rPr><w:t>$(X $t)</w:t></w:r></w:p>" }
# Company + right-aligned location/dates on ONE line via a right tab stop (no tables: ATS-safe)
function CompanyRow($company, $where) { "<w:p><w:pPr><w:keepNext/><w:tabs><w:tab w:val=`"right`" w:pos=`"10656`"/></w:tabs><w:spacing w:after=`"0`"/>$P20</w:pPr><w:r><w:rPr>$F<w:b/><w:color w:val=`"1F4E79`"/><w:sz w:val=`"20`"/><w:szCs w:val=`"24`"/></w:rPr><w:t>$(X $company)</w:t></w:r><w:r><w:rPr>$F<w:color w:val=`"5A5A5A`"/><w:szCs w:val=`"24`"/></w:rPr><w:tab/><w:t>$(X $where)</w:t></w:r></w:p>" }
function Intro($t) { "<w:p><w:pPr><w:keepNext/><w:spacing w:before=`"8`" w:after=`"20`" w:line=`"240`" w:lineRule=`"auto`"/>$P20</w:pPr><w:r><w:rPr>$F<w:i/><w:color w:val=`"5A5A5A`"/><w:sz w:val=`"20`"/><w:szCs w:val=`"24`"/></w:rPr><w:t>$(X $t)</w:t></w:r></w:p>" }
function Bullet($numId, $t) { "<w:p><w:pPr><w:pStyle w:val=`"ListParagraph`"/><w:keepLines/><w:numPr><w:ilvl w:val=`"0`"/><w:numId w:val=`"$numId`"/></w:numPr><w:spacing w:after=`"24`" w:line=`"240`" w:lineRule=`"auto`"/>$P20</w:pPr><w:r><w:rPr>$F<w:color w:val=`"232323`"/><w:szCs w:val=`"24`"/></w:rPr><w:t>$(X $t)</w:t></w:r></w:p>" }
function TwoPart($bold, $rest, $after) { "<w:p><w:pPr><w:spacing w:after=`"$after`"/>$P20</w:pPr><w:r><w:rPr>$F<w:b/><w:color w:val=`"232323`"/><w:sz w:val=`"20`"/><w:szCs w:val=`"24`"/></w:rPr><w:t>$(X $bold)</w:t></w:r><w:r><w:rPr>$F<w:color w:val=`"5A5A5A`"/><w:sz w:val=`"20`"/><w:szCs w:val=`"24`"/></w:rPr><w:t xml:space=`"preserve`">$(X $rest)</w:t></w:r></w:p>" }
function Plain($t) { "<w:p><w:pPr><w:spacing w:after=`"0`"/>$P20</w:pPr><w:r><w:rPr>$F<w:color w:val=`"232323`"/><w:szCs w:val=`"24`"/></w:rPr><w:t xml:space=`"preserve`">$(X $t)</w:t></w:r></w:p>" }

# ---------- document.xml ----------
$docPath = Join-Path $unpacked 'word\document.xml'
$orig = ReadU $docPath
$cut = $orig.IndexOf('<w:p w14:paraId="5CC89F3A"')          # SUMMARY heading of the base template
if ($cut -lt 0) { throw 'Template mismatch: SUMMARY anchor not found (base must be the 2026.08.29 CV).' }
$prefix = $orig.Substring(0, $cut)                           # name + headline + contact line
if (-not $c.name -or -not $c.contact) { throw 'content.json needs "name" and "contact" {line, linkedin, linkedinUrl} (the template only holds placeholders).' }
# text runs in the header, in order: name, headline, contact line, LinkedIn handle (inside the hyperlink)
$header = @($c.name.ToUpper(), $c.headline, "$($c.contact.line)  |  LinkedIn: ", $c.contact.linkedin)
$m = [regex]::Matches($prefix, '<w:t( xml:space="preserve")?>([^<]*)</w:t>')
if ($m.Count -lt 4) { throw 'Header runs (name, headline, contact, LinkedIn) not found in template.' }
for ($k = 3; $k -ge 0; $k--) {                                # right to left so indexes stay valid
  $prefix = $prefix.Substring(0, $m[$k].Index) + "<w:t xml:space=`"preserve`">$(X $header[$k])</w:t>" + $prefix.Substring($m[$k].Index + $m[$k].Length)
}
$suffix = $orig.Substring($orig.IndexOf('<w:sectPr'))

$numIds = @('19', '21', '23', '26')                           # bullet list ids in the template; extra jobs reuse the last
$sb = New-Object System.Text.StringBuilder
[void]$sb.Append($prefix)
[void]$sb.Append((Heading 'SUMMARY')); [void]$sb.Append((Summary $c.summary))
[void]$sb.Append((Heading 'CORE SKILLS'))
foreach ($s in $c.skills) { [void]$sb.Append((SkillLine $s[0] $s[1])) }
[void]$sb.Append((Heading 'PROFESSIONAL EXPERIENCE'))
$i = 0
foreach ($j in $c.jobs) {
  $nid = if ($j.numId) { $j.numId } else { $numIds[[Math]::Min($i, $numIds.Count - 1)] }
  [void]$sb.Append((JobTitle $j.title)); [void]$sb.Append((CompanyRow $j.company $j.where))
  if ($j.intro) { [void]$sb.Append((Intro $j.intro)) }
  foreach ($b in $j.bullets) { [void]$sb.Append((Bullet $nid $b)) }
  $i++
}
[void]$sb.Append((Heading 'EDUCATION'))
for ($k = 0; $k -lt $c.education.Count; $k++) {
  $after = if ($k -eq $c.education.Count - 1) { '30' } else { '10' }
  [void]$sb.Append((TwoPart $c.education[$k][0] $c.education[$k][1] $after))
}
if ($c.certs) { [void]$sb.Append((Heading 'SELECTED CERTIFICATIONS')); [void]$sb.Append((Plain $c.certs)) }
if ($c.languages) { [void]$sb.Append((Heading 'LANGUAGES')); [void]$sb.Append((Plain $c.languages)) }
[void]$sb.Append($suffix)
WriteU $docPath $sb.ToString()
$null = [xml](ReadU $docPath)

# ---------- footer: never leave the previous role in it ----------
Get-ChildItem (Join-Path $unpacked 'word') -Filter 'footer*.xml' | ForEach-Object {
  $t = ReadU $_.FullName
  $t = [regex]::Replace($t, '<w:t([^>]*)>[^<|]+\|[^<]*</w:t>', "<w:t`$1>$(X $c.name) | $(X $c.footer)</w:t>")
  WriteU $_.FullName $t
}
# ---------- LinkedIn hyperlink target ----------
$relsPath = Join-Path $unpacked 'word\_rels\document.xml.rels'
$t = [regex]::Replace((ReadU $relsPath), 'Target="https://www\.linkedin\.com/in/[^"]*"', "Target=`"$(X $c.contact.linkedinUrl)`"")
WriteU $relsPath $t
# ---------- bullets: Symbol-font glyph -> Unicode bullet in Arial (extracts cleanly) ----------
$numPath = Join-Path $unpacked 'word\numbering.xml'
$t = (ReadU $numPath).Replace([string][char]0xF0B7, [string][char]0x2022)
$t = $t -replace 'w:ascii="Symbol" w:hAnsi="Symbol"( w:hint="default")?', 'w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"'
WriteU $numPath $t
# ---------- metadata: title, author, no "generated by python-docx" ----------
$corePath = Join-Path $unpacked 'docProps\core.xml'
$t = ReadU $corePath
$t = [regex]::Replace($t, '<dc:title>[^<]*</dc:title>', "<dc:title>$(X $c.docTitle)</dc:title>")
$t = [regex]::Replace($t, '<dc:creator>[^<]*</dc:creator>', "<dc:creator>$(X $c.name)</dc:creator>")
$t = [regex]::Replace($t, '<cp:lastModifiedBy>[^<]*</cp:lastModifiedBy>', "<cp:lastModifiedBy>$(X $c.name)</cp:lastModifiedBy>")
$t = [regex]::Replace($t, '<dc:description>[^<]*</dc:description>', '<dc:description></dc:description>')
WriteU $corePath $t

# ---------- zip (forward-slash entries, [Content_Types].xml first) ----------
New-Item -ItemType Directory -Force $OutDir | Out-Null
$docx = Join-Path (Resolve-Path $OutDir).Path "$BaseName.docx"
$pdf = [IO.Path]::ChangeExtension($docx, '.pdf')
if (Test-Path -LiteralPath $docx) { Remove-Item -LiteralPath $docx -Force }
$root = (Resolve-Path $unpacked).Path
$fs = [IO.File]::Open($docx, 'Create')
$zip = New-Object System.IO.Compression.ZipArchive($fs, [System.IO.Compression.ZipArchiveMode]::Create)
Get-ChildItem -LiteralPath $root -Recurse -File | Sort-Object { if ($_.Name -eq '[Content_Types].xml') { 0 } else { 1 } }, FullName | ForEach-Object {
  [void][System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, $_.FullName.Substring($root.Length + 1).Replace('\', '/'))
}
$zip.Dispose(); $fs.Dispose()

# ---------- PDF via Word (kills only its own hidden automation instance on failure) ----------
$before = @(Get-Process WINWORD -ErrorAction SilentlyContinue | ForEach-Object Id)
$word = New-Object -ComObject Word.Application
$word.Visible = $false; $word.DisplayAlerts = 0
try {
  $doc = $word.Documents.Open($docx, $false, $false)
  $doc.Save()
  $pages = $doc.ComputeStatistics(2)
  $doc.ExportAsFixedFormat($pdf, 17)
  $doc.Close($false)
} finally {
  try { $word.Quit() } catch {}
  [void][Runtime.InteropServices.Marshal]::ReleaseComObject($word)
  Start-Sleep -Seconds 1
  Get-Process WINWORD -ErrorAction SilentlyContinue | Where-Object { $before -notcontains $_.Id } |
    Where-Object { (Get-CimInstance Win32_Process -Filter "ProcessId=$($_.Id)").CommandLine -match '/Automation' } |
    Stop-Process -Force -ErrorAction SilentlyContinue
}

# ---------- ATS checks with Poppler ----------
$pop = Get-ChildItem "$env:LOCALAPPDATA\Microsoft\WinGet\Packages" -Recurse -Filter pdftotext.exe -ErrorAction SilentlyContinue | Select-Object -First 1
"docx  : $docx"
"pdf   : $pdf"
"pages : $pages"
if ($pop) {
  $bin = $pop.DirectoryName
  $raw = Join-Path $WorkDir 'raw.txt'
  & "$bin\pdftotext.exe" -raw $pdf $raw
  Get-ChildItem $WorkDir -Filter 'page-*.png' -ErrorAction SilentlyContinue | Remove-Item -Force
  & "$bin\pdftoppm.exe" -png -r 80 $pdf (Join-Path $WorkDir 'page')
  $text = ReadU $raw
  $hits = @($c.banned | Where-Object { $_ -and $text -match ('\b' + [regex]::Escape($_) + '\b') })
  "ats   : $raw"
  "png   : " + ((Get-ChildItem $WorkDir -Filter 'page-*.png' | ForEach-Object FullName) -join ', ')
  if ($hits.Count) { "BANNED TERMS FOUND: " + ($hits -join ', ') } else { 'banned: none found' }
} else {
  'Poppler not found: install with  winget install --id oschwartz10612.Poppler -e  to enable ATS/visual checks.'
}
