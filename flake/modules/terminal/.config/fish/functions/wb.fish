function wb 
    argparse h/help s/start r/restart q/quit -- $argv
    or return

    if set -ql _flag_help
        echo "wb [-h|--help] [-s|--start] [-r|--restart] [-q|--quit]"
        return 0
    end

    if set -ql _flag_start
       background waybar
    end

    if set -ql _flag_restart
        pkill waybar
        background waybar
    end

    if set -ql _flag_quit
        pkill waybar
    end

    if not set -ql _flag_start
        if not set -ql _flag_restart
            if not set -ql _flag_quit
                wb -r
            end
        end
    end
end