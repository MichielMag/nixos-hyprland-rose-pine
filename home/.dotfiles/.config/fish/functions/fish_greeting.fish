function fish_greeting
	set terminal_class (terminal-class)
    set term (string match -r '.*runner' $terminal_class)
    set l (string length "$term")
    if test "$l" -gt 0
        return
    end
    fastfetch --logo-padding-top 2
end