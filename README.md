# simple-clipboard.yazi

> [!Important]
> Made for Xorg. PR for Wayland. Also dynamic clipboard detection would be appriciated.

## Configuration

Copy or install this plugin and add the following keymap to your `manager.prepend_keymap`:

```toml
{
  on = "y";
  run = ["plugin --sync simple-clipboard", "yank"];
}
```

This extension doesn't support multiple 
file copy&paste, and has some limitations
like some apps may not understand what
you are trying to paste.

Check out my repo `system-clipboard`.
