Migrating to MrCode (Linux)
===========================

Backup
------

### VSCode

```sh
mkdir -p User/snippets

# Backup settings files
cp ~/.config/Code/User/keybindings.json User/
cp ~/.config/Code/User/settings.json User/
cp ~/.config/Code/User/snippets/* User/snippets/

# Export extension list
code --list-extensions | sort -f -o vscode-extensions.txt
```

### VSCodium

```sh
mkdir -p User/snippets

# Backup settings files
cp ~/.config/VSCodium/User/keybindings.json User/
cp ~/.config/VSCodium/User/settings.json User/
cp ~/.config/VSCodium/User/snippets/* User/snippets/

# Export extension list
codium --list-extensions | sort -f -o vscode-extensions.txt
```

Restore
-------

```sh
# Restore settings files
cp -r User/* ~/.config/MrCode/User/

# Import extensions
for LINE in $(cat "vscode-extensions.txt")
do
  printf "%b%s%b\n" "\e[44m" "$LINE" "\e[49m"
  mrcode --install-extension "$LINE"
  echo -e "\n"
done
```