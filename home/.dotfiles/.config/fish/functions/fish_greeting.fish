function fish_greeting
	set terminal_class (terminal-class)
    set term (string match -r 'full' $terminal_class)
    set l (string length "$term")
    if test "$l" -gt 0
        fastfetch --logo-padding-top 2
    end
end