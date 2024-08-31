function mp4togif --wraps='ffmpeg'
    ffmpeg -i $argv[1] $argv[2]
end
