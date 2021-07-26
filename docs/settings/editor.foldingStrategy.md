editor.foldingStrategy
======================

The setting `editor.foldingStrategy` is extended to use the folding ranges provided by only one extension.

For example, if you are using the extension [Explicit Folding](https://github.com/zokugun/vscode-explicit-folding):

Traditionally, VSCode is using the folding ranges provided:
- by the folding range provider defined by the setting `editor.foldingStrategy` (`auto` or `indentation`)
- <ins>**and**</ins> by the folding range provider defined by that extension if `editor.foldingStrategy` is set to `auto`

With [MrCode](https://github.com/zokugun/MrCode), it's using the folding ranges provided:
- by the folding range provider defined by the setting `editor.foldingStrategy` (`auto` or `indentation`)
- <ins>**or**</ins> by the folding range provider defined by that extension if `editor.foldingStrategy` is set to `explicit`

Composite strategy
------------------

`editor.foldingStrategy` can combine differents folding range providers with the operators `&` and `|`:

- `language | indentation`: folding ranges from a language provider or, if none found, from the indentation provider
- `explicit & indentation`: folding ranges from the explicit provider and from the indentation provider

`editor.foldingStrategy` supports only identical operators:
- `language | explicit | indentation` is valid
- `language | explicit & indentation` isn't and will be defaulted to `auto`.

`auto` becomes an alias for `language | indentation`.
