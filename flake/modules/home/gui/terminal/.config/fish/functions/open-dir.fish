function open-dir --wraps='xdg-open . > /dev/null 2>&1 &' --description 'alias open-dir=xdg-open . > /dev/null 2>&1 &'
  xdg-open . > /dev/null 2>&1 & $argv
end
