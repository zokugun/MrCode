<div align="center">
<img src="./src/src/resources/linux/code.png" width="200"/>
<h1><a href="https://github.com/zokugun/MrCode">MrCode</a></h1>

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/zokugun/MrCode/blob/master/LICENSE)
[![current release](https://img.shields.io/github/release/zokugun/MrCode.svg?colorB=green)](https://github.com/zokugun/MrCode/releases)
[![macOS](https://github.com/zokugun/MrCode/workflows/windows/badge.svg)](https://github.com/zokugun/MrCode/actions?query=workflow%3Awindows)
[![macOS](https://github.com/zokugun/MrCode/workflows/macOS/badge.svg)](https://github.com/zokugun/MrCode/actions?query=workflow%3AmacOS)
[![linux](https://github.com/zokugun/MrCode/workflows/linux/badge.svg)](https://github.com/zokugun/MrCode/actions?query=workflow%3Alinux)

</div>

MrCode is a custom build of [VSCodium](https://github.com/VSCodium/vscodium) / [VSCode](https://github.com/microsoft/vscode).

Download
--------

[Download latest release here](https://github.com/zokugun/MrCode/releases)

What's the difference?
----------------------

### Patched Settings

- [editor.foldingStrategy](./docs/settings/editor.foldingStrategy.md)
- [editor.showFoldingLastLine](./docs/settings/editor.showFoldingLastLine.md)
- [keyboard.platform](./docs/settings/keyboard.platform.md)
- terminal.integrated.enableUriLinks
- terminal.integrated.enableWordLinks
- [workbench.editor.openPositioning](./docs/settings/workbench.editor.openPositioning.md)

### Patched Commands

- [workbench.extensions.disableExtension](./docs/commands/workbench.extensions.disableExtension.md)
- [workbench.extensions.enableExtension](./docs/commands/workbench.extensions.enableExtension.md)

### Patched Features

- render and copy tab characters in the terminal

### split JSON settings editor

I will try to add back the split JSON settings editor via an extension.

Supported OS
------------

- [x] Windows 7, 8, 10 (`x64`, `x86`, `arm64`)
- [x] macOS 10.10+ (`x64`)
- [x] Linux (`AppImage`, `deb`, `rpm`, `tar.gz`) (`x64`, `arm64`, `armhf`)

Supported App/Package Managers
------------------------------

- [AUR](https://aur.archlinux.org/packages/?K=mrcode)

FAQ
---

**Q:** How to migrate to MrCode?

**A:** You can read the following documentation: [How to Migrate](./docs/migrate/index.md)

**Q:** How do I open MrCode from the terminal?

**A:** Please read the documentation: [Install `mrcode` command](./docs/terminal.md)

News
----

- [VS Code Updates](https://code.visualstudio.com/updates)

License
-------

[MIT](http://www.opensource.org/licenses/mit-license.php)

**Enjoy!**
