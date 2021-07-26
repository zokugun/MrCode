editor.showFoldingLastLine
==========================

The setting `editor.showFoldingLastLine` determines if the last line of the folding range is shown or not.
By default, VSCode show the last line so its default value is `true`.

The folding ranges aren't modified by that setting if the folding ranges are provided:
- by the builtin indentation provider
- or by a provider with the flag `isManagingLastLine` equals to `true`.
