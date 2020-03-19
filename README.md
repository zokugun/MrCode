[MrCode](https://github.com/zokugun/MrCode)
===================================================

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE)
[![current release](https://img.shields.io/github/release/zokugun/MrCode.svg)](./releases)

MrCode is a liberated version of [VSCode](https://github.com/microsoft/vscode). It's based on [VSCodium](https://github.com/VSCodium/vscodium) and so have the same [licensing issue](https://github.com/VSCodium/vscodium/blob/master/DOCS.md#proprietary-debugging-tools).

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

The setting `editor.foldingStrategy` is extends to support only the folding strategy of a extension.

For example:

I have the extension [Explicit Folding](https://github.com/zokugun/vscode-explicit-folding) which allows to manually control how to folds your code.

VSCode will use the folding ranges defined by this extension with the others folding ranges either defined by the langauge or by the indentation.

By setting `editor.foldingStrategy = 'explicit'`, it will only use the folding ranges of that extension. (`explicit` is the id given to the FoldingProvider of that extension)

[PR](https://github.com/microsoft/vscode/pull/54200)

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

Migrating to MrCode
-------------------

### Backup VSCode

Visual Studio Code stores your settings at:

- __Windows__: `%APPDATA%\Code\User`
- __macOS__: `~/Library/Application Support/Code/User`
- __Linux__: `~/.config/Code/User`

Use the following script to export them:

```
mkdir -p User/snippets

# Backup settings files
cp ~/Library/Application\ Support/Code/User/keybindings.json User/
cp ~/Library/Application\ Support/Code/User/settings.json User/
cp ~/Library/Application\ Support/Code/User/snippets/* User/snippets/

# Export extension list
code --list-extensions | sort -f -o vscode-extensions.txt
```

### Restore to MrCode

MrCode stores your settings at:

- __Windows__: `%APPDATA%\MrCode\User`
- __macOS__: `~/Library/Application Support/MrCode/User`
- __Linux__: `~/.config/MrCode/User`

Use the following script to import them:

```
# Restore settings files
cp -R User/* ~/Library/Application\ Support/MrCode/User/

# Import extensions
for LINE in $(cat "vscode-extensions.txt")
do
  printf "%b%s%b\n" "\e[44m" "$LINE" "\e[49m"
  mrcode --install-extension "$LINE"
  echo -e "\n"
done
```

License
-------

[MIT](http://www.opensource.org/licenses/mit-license.php)