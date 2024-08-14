# system-clipboard.yazi

## Demo

https://github.com/user-attachments/assets/74d59f49-266a-497e-b67e-d77e64209026

## Config

> [!NOTE]
> You need yazi 3.x for this plugin to work.

> [!Important]
> This plugin wraps around the magnificent ["ClipBoard" project](https://github.com/Slackadays/ClipBoard).
> You need to have it installed on your system. (Make sure that It's on your $PATH)

## Configuration

Copy or install this plugin and add the following keymap to your `manager.prepend_keymap`:

```toml
on = "<C-y>"
run = ["plugin system-clipboard"]
```

> [!Tip]
> If you want to use this plugin with yazi's default yanking behaviour you should use `cx.yanked` instead of `tab.selected` in `init.lua` (See [#1487](https://github.com/sxyazi/yazi/issues/1487))
