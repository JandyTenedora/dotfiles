# Neovim Config

Personal Neovim configuration managed with [Lazy.nvim](https://github.com/folke/lazy.nvim).

## Plugins overview

- **Plugin manager**: Lazy.nvim
- **LSP**: nvim-lspconfig + mason-lspconfig (lua_ls, gopls, pyright), nvim-metals (Scala)
- **Completion**: nvim-cmp + cmp-nvim-lsp
- **Formatting**: none-ls (stylua, gofumpt, goimports-reviser, golines, scalafmt)
- **Syntax**: nvim-treesitter (lua, javascript, scala)

## External prerequisites

Most LSPs are installed automatically via Mason. The following require manual host installation.

### Scala / Metals

Metals is not in Mason's registry and requires Java 17+. Follow these steps once on a new machine.

**1. Install Java 17 via SDKMAN**

```bash
curl -s "https://get.sdkman.io" | bash
source ~/.sdkman/bin/sdkman-init.sh
sdk install java 17.0.14-tem
sdk default java 17.0.14-tem
```

Verify: `java -version` should report 17.x.x.

**2. Install coursier and Metals**

```bash
brew install coursier
brew install metals
```

**3. First launch in a Scala project**

Open any `.scala` file in Neovim, then run:

```
:MetalsInstall
:MetalsImportBuild
```

Use `:MetalsDoctor` to check the health of the setup.

**4. sbt version requirement**

Metals requires sbt 1.9.0+. In each Scala project, ensure `project/build.properties` has:

```
sbt.version=1.10.7
```

After updating, run `:MetalsImportBuild` inside Neovim to pick up the change.
