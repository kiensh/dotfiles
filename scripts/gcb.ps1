
if (!$args) { Write-Error("Error: Null - Expect branch name"); return }
$target = $args[0]
git checkout -b $target

