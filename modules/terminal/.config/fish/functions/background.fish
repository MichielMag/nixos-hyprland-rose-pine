function background
    set -l cmd $argv
    set -l pid ($cmd > /dev/null 2>&1 & echo $pid) 
end