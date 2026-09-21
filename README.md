### Awesome Config

* For SDDM, logs are written to ~/.local/share/sddm/xorg-session.log

### Set a wallpaper

The theme reads the image path from `~/.config/variety/wallpaper/wallpaper.txt`.
To set an image and reload AwesomeWM, run:

```bash
mkdir -p ~/.config/variety/wallpaper
```

```bash
printf '%s\n' "$HOME/.config/awesome/themes/simple/tmp/1413712.png" > ~/.config/variety/wallpaper/wallpaper.txt
```

```bash
awesome-client 'awesome.restart()'
```
