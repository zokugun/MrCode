<div align="center">
<img src="./src/src/stable/resources/linux/code.png" width="200"/>
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

- <del>editor.foldingStrategy</del> replaced with builtin setting `editor.defaultFoldingRangeProvider`
- <del>editor.showFoldingLastLine</del>
- <del>[keyboard.platform](./docs/settings/keyboard.platform.md)</del> (WIP)
- <del>terminal.integrated.enableUriLinks</del>
- <del>terminal.integrated.enableWordLinks</del>
- <del>workbench.editor.openPositioning</del> replaced with extension [Automatic Editor Sorter](https://open-vsx.org/extension/zokugun/automatic-editor-sorter)

### Patched Commands

- [workbench.extensions.disableExtension](./docs/commands/workbench.extensions.disableExtension.md)
- [workbench.extensions.enableExtension](./docs/commands/workbench.extensions.enableExtension.md)

### Patched Features

- render and copy tab characters in the terminal (https://github.com/daiyam/xterm-tab)

Supported Platforms
-------------------

- [x] macOS (`zip`, `dmg`) macOS 10.15 or newer x64
- [x] macOS (`zip`, `dmg`) macOS 11.0 or newer arm64
- [x] GNU/Linux x64 (`deb`, `rpm`, `AppImage`, `snap`, `tar.gz`)
- [x] GNU/Linux arm64 (`deb`, `rpm`, `snap`, `tar.gz`)
- [x] GNU/Linux armhf (`deb`, `rpm`, `tar.gz`)
- [x] GNU/Linux riscv64 (`tar.gz`)
- [x] GNU/Linux loong64 (`tar.gz`)
- [x] GNU/Linux ppc64le (`tar.gz`)
- [x] Windows 10 / Server 2012 R2 or newer x64
- [x] Windows 10 / Server 2012 R2 or newer arm64

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
