$pde_files = Get-ChildItem -Path src -r -Filter *.pde -Name

# ビルド先をクリア
if (Test-Path libroilustrado) {
    Remove-Item -Path libroilustrado/*.pde -Recurse -Force
}

New-Item -ItemType Directory -Force libroilustrado

# パスをファイル名にならしながらコピー
foreach ($pde_file_path in $pde_files) {
    $pde_file_name_normalized = $pde_file_path.Replace("\", "_").Replace("/", "_").Split("_");
    if ($pde_file_name_normalized.Length -gt 1) {
        $pde_file_name_normalized = ($pde_file_name_normalized[0..($pde_file_name_normalized.Length-2)] -join "_") + ".pde";
    } else {
        $pde_file_name_normalized = ($pde_file_name_normalized -join "_");
    }
    #Add-Content -Encoding Default -Value ((Get-Content src\$pde_file_path) + "`n") "blockbreaking/$pde_file_name_normalized"
    Add-Content -Encoding Default -Value (Get-Content src\$pde_file_path) "libroilustrado/$pde_file_name_normalized"
    #Add-Content -Encoding Byte -Value ((Get-Content -Encoding UTF8 src\$pde_file_path) + "`n" | Out-String | % { [Text.Encoding]::UTF8.GetBytes($_) }) "libroilustrado/$pde_file_name_normalized"
}

# データフォルダをコピー
Copy-Item -Force -Recurse -Literal data -Destination libroilustrado 

# バージョン情報を付加
$commit_info = git log --date=format:"%m/%d %H:%M" --format='%h(%cd)' --max-count=1
$dirty_file = $(git status --porcelain).Count

if ($dirty_file -eq 0) {
    $version = "$commit_info"
} else {
    $version = "$commit_info(+$dirty_file file(s) modified)"
}

New-Item ./libroilustrado/version.pde -Value "String VERSION = `"$version`";"
