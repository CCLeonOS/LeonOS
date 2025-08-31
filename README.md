# LeonOS

###### look, mom, a proper Markdown readme!

LeonOS is a reimplementation of [CC: Tweaked](https://github.com/CC-Tweaked/CC-Tweaked)'s LeonOS, intended to be cleaner and easier than the original LeonOS.

Key changes:

 - No. More. CCPL!!
 - All previously global APIs (with the exception of the standard Lua ones) have been removed.
 - Non-standard `os` API functions are now in the `rc` table, e.g. `os.sleep` becomes `rc.sleep` or `os.pullEvent` becomes `rc.pullEvent`.
 - Native support for proper thread management (`parallel` implementation builds on this)
 - Multishell works even on standard computers, and is navigable with keyboard shortcuts!

See [the LeonOS website](https://ocaweso.me/LeonOS) for more details.
