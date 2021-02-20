<div align="center">
<img src="./src/src/resources/linux/code.png" width="200"/>
<h1><a href="https://github.com/zokugun/MrCode">MrCode</a></h1>

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/zokugun/MrCode/blob/master/LICENSE)
[![current release](https://img.shields.io/github/release/zokugun/MrCode.svg?colorB=green)](https://github.com/zokugun/MrCode/releases)
[![macOS](https://github.com/zokugun/MrCode/workflows/windows/badge.svg)](https://github.com/zokugun/MrCode/actions?query=workflow%3Awindows)
[![macOS](https://github.com/zokugun/MrCode/workflows/macOS/badge.svg)](https://github.com/zokugun/MrCode/actions?query=workflow%3AmacOS)
[![linux](https://github.com/zokugun/MrCode/workflows/linux/badge.svg)](https://github.com/zokugun/MrCode/actions?query=workflow%3Alinux)

</div>

MrCode is a _liberated_ version of [VSCode](https://github.com/microsoft/vscode). It's based on [VSCodium](https://github.com/VSCodium/vscodium) and so have the same [licensing issue](https://github.com/VSCodium/vscodium/blob/master/DOCS.md#proprietary-debugging-tools).

Download
--------

[Download latest release here](./releases)

Why liberated?
--------------

For almost 2 years, I'm running a custom build to fix some of issues I have with VSCode. I've made some PRs but they are either in limbo or rejected.

So I've decided to make available to every one and to use [VSCodium](https://github.com/VSCodium/vscodium) as a very good base.

Here the extra features:

### workbench.editor.openPositioning

The setting `workbench.editor.openPositioning` has a new option: `sort`

It can be controlled by 2 new settings:
- `workbench.editor.openPositioningSortOrder`: `'asc' | 'desc'`
- `workbench.editor.openPositioningSortRule`: `'name-local' | 'name-absolute' | 'absolute'`

[PR](https://github.com/microsoft/vscode/pull/54008)

### editor.foldingStrategy

The setting `editor.foldingStrategy` is extended to use the folding ranges provided by only one extension.

For example, if you are using the extension [Explicit Folding](https://github.com/zokugun/vscode-explicit-folding):

Traditionally, VSCode is using the folding ranges provided:
- by the folding range provider defined by the setting `editor.foldingStrategy` (`auto` or `indentation`)
- <ins>**and**</ins> by the folding range provider defined by that extension if `editor.foldingStrategy` is set to `auto`

With [MrCode](https://github.com/zokugun/MrCode), it's using the folding ranges provided:
- by the folding range provider defined by the setting `editor.foldingStrategy` (`auto` or `indentation`)
- <ins>**or**</ins> by the folding range provider defined by that extension if `editor.foldingStrategy` is set to `explicit`

#### Composite strategy

Since `v1.52.1`, `editor.foldingStrategy` can combine differents folding range providers with the operators `&` and `|`:

- `language | indentation`: folding ranges from a language provider or, if none found, from the indentation provider
- `explicit & indentation`: folding ranges from the explicit provider and from the indentation provider

`editor.foldingStrategy` supports only identical operators:
- `language | explicit | indentation` is valid
- `language | explicit & indentation` isn't and will be defaulted to `auto`.

`auto` becomes an alias for `language | indentation`.


[PR](https://github.com/microsoft/vscode/pull/54200)

### editor.showFoldingLastLine

The setting `editor.showFoldingLastLine` determines if the last line of the folding range is shown or not.
By default, VSCode show the last line so its default value is `true`.

The folding ranges aren't modified by that setting if the folding ranges are provided:
- by the builtin indentation provider
- or by an extension with the flag `isManagingLastLine` equals to `true`.

Supported OS
------------

- [x] Linux x64 (`AppImage`, `deb`, `rpm`, `tar.gz`)
- [x] Linux arm64 (`deb`, `tar.gz`)
- [x] Linux armhf (`deb`, `tar.gz`)
- [x] macOS x64 (`dmg`, `zip`)
- [x] Windows x64 (`exe`, `zip`)
- [x] Windows x86 (`exe`, `zip`)
- [x] Windows arm64 (`exe`, `zip`)

Migrating to MrCode
-------------------

MrCode stores your settings at:

- __Windows__: `%APPDATA%\MrCode\User`
- __macOS__: `~/Library/Application Support/MrCode/User`
- __Linux__: `~/.config/MrCode/User`

Use the following scripts to migrate:

- [Windows](./docs/migrate-windows.md)
- [macOS](./docs/migrate-macos.md)
- [Linux](./docs/migrate-linux.md)

How do I open MrCode from the terminal?
---------------------------------------

- Go to the command palette (View | Command Palette...)
- Choose `Shell command: Install 'mrcode' command in PATH`.

![](https://user-images.githubusercontent.com/587742/77121228-018f3a80-6a3b-11ea-8189-9dfe080d1a65.jpg)

This allows you to open files or directories in MrCode directly from your terminal:

```bash
~/in-my-project $ mrcode . # open this directory
~/in-my-project $ mrcode file.txt # open this file
```

News
----

- [VS Code Updates](https://code.visualstudio.com/updates)

License
-------

[MIT](http://www.opensource.org/licenses/mit-license.php)

**Enjoy!**