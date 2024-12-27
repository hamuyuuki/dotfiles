# dotfiles

![CI](https://github.com/hamuyuuki/dotfiles/workflows/CI/badge.svg)

## Create new fine-grained personal access token

- Token name
  - Using dotfiles
- Repository access > Only select repositories
  - hamuyuuki/dotfiles
- Permissions > Repository permissions
  - Contents: Read-only
  - Metadata: Read-only

## macOS Sequoia 15

```bash
/bin/zsh -c "$(curl -fsSL -H 'Authorization: token ${PAT}' https://raw.githubusercontent.com/hamuyuuki/dotfiles/master/setup.sh)"
```
