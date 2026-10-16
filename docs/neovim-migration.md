# Plan: replace VS Code with Neovim (in iTerm2) for beancount + markdown

## Context

Today: VS Code + VSCodeVim (Neovim-backed, `U`→redo), the Lencerf "Beancount" extension (highlighting,
bean-check diagnostics), and your `vscode-aaronsbeancountutils` extension (`src/extension.ts`): inline
calculator (`calculate()` + `src/calculator.jison`, decimal.js, posting×cost, result → clipboard),
`bean-doctor context` in a new tab, and an outline from org-style `*` headers (a DocumentSymbolProvider;
"statement" headers are SymbolKind.Constant and hidden via `[beancount] outline.showConstants: false`).
VS Code keeps pushing Copilot/AI subscriptions. The old Vim setup is dead weight: `home_files/vimrc` +
`gvimrc` (pathogen, MacVim, Google-only blocks), `dotvim` (pathogen + 11 submodules, last change 2020),
`setup_dot_vim.sh` (clones from a defunct server).

**Decisions (from your answers):** Neovim 0.12 in iTerm2, no GUI app · Cmd-P behaves like VS Code Quick
Open (files; `@` symbols; `$` buffers) and Cmd-Shift-P opens the command palette · old Vim setup removed ·
built-in netrw as the file tree · beancount highlighting comes from the language server only (no nvim-treesitter).

## Options considered (summary)

| | Neovim 0.12 ✅ | Sublime Text 4 + NeoVintageous | Zed (vim mode) | Emacs + Evil | VS Code/VSCodium, AI off |
|---|---|---|---|---|---|
| Vim | real Vim | good emulation | good emulation | Evil (very good) | as today |
| Beancount | beancount-language-server (highlighting, errors, completion); your extension ported | pkg + LSP; plugins in Python | extension + LSP; calc needs a custom LSP (no edit API) | official beancount-mode (outline + bean-check built in) | as today |
| Cmd-P | iTerm2 key mapping → `<D-p>` | native | native | bind `s-p` | native |
| Scripting | Lua; Python via scripts / pynvim | Python (first-class) | none (Rust→WASM) | Emacs Lisp | TypeScript |
| Upsell | none (OSS) | none ($99 license) | AI is the business (`"disable_ai": true`) | none | continues (`"chat.disableAIFeatures": true`) |

Excluded: Helix/Kakoune (not vim keys; Helix plugins unmerged), MacVim/Vim 9 (weaker LSP/tree-sitter ecosystem).

## Do you need Neovide? No.

Neovide is only a GUI window around the same Neovim and the same config. Nothing on your list needs it.
Specifically, it would add:
1. **Cmd shortcuts without setup.** Inside a terminal, macOS sends ⌘-combos to iTerm2's menus, never to
   the program. In Neovide every ⌘-combo arrives as `<D-…>`. In iTerm2, each ⌘ shortcut you want costs one
   key mapping that sends a CSI-u escape sequence; Neovim ≥0.10 decodes those as `<D-p>`. We need two: ⌘P and ⌘⇧P.
   (⌘⇧O, VS Code's Go to Symbol, is iTerm2's "Open Quickly". So symbols go through ⌘P then `@`, which is
   VS Code's own Quick Open flow.)
2. **Animated smooth scrolling** (you had `editor.smoothScrolling` on). Terminal scrolling is line-by-line.
3. **Mac-app conveniences:** Dock icon, Finder "Open With", per-window font size.

What it would cost: a second app outside your iTerm2 workflow. It also starts without `.zshrc`, so PATH
would have to move to `.zprofile`. Adding it later takes `brew install --cask neovide-app` plus an
`if vim.g.neovide` block.

## Implementation

### Layout (dotfiles repo)
```
home_files/nvim/                        -> ~/.config/nvim (directory symlink; vim.pack's lockfile lands in git)
  init.lua                              options, keymaps, plugins (vim.pack), LSP, diagnostics, autocmds
  nvim-pack-lock.json                   written by vim.pack; committed
  lsp/beancount.lua                     beancount-language-server config
  lsp/beancount_outline.lua             in-process outline "server" (cmd = Lua function)
  lua/aaron/palette.lua                 Cmd-Shift-P command palette
  lua/aaron/beancount/outline.lua       header parser + documentSymbol server + foldexpr + filtered gO
  lua/aaron/beancount/doctor.lua        :BeanDoctor
  lua/aaron/beancount/calc.lua          :BeanCalc glue
  lua/aaron/markdown.lua                :MarkdownPreview
  after/ftplugin/beancount.lua          commentstring, folds, buffer-local maps/commands (all with desc)
  after/ftplugin/markdown.lua           spell, preview mapping
  python/beancalc.py                    calculator (port of calculator.jison + calculate())
  python/test_beancalc.py               unittest port of src/test/suite/extension.test.ts + edge cases
  tests/spec.lua, tests/fixtures/       headless checks (nvim -l), fixture ledger + markdown
```

### Steps
1. **Prereqs (brew):** `neovim` (0.12.5) `fzf` (≥ 0.74.5) `fd` `ripgrep` `beancount-language-server`
   `pandoc`. No tree-sitter CLI or C compiler needed. bean-check/bean-doctor as you have them now. Optional: `uv tool install pynvim` adds Python
   scripting inside Neovim (`:py3`, Python remote plugins).
2. **Bootstrap:** in `copy_files_to_home_folder.sh`, drop `vimrc`/`gvimrc` from the symlink loop and add
   `mkdir -p ~/.config && ln -sfn "$home_files_dir/nvim" ~/.config/nvim`.
3. **Core (`init.lua`), curated from vimrc and VS Code:**
   - Keys: leader `,` · `U`→`<C-r>` · `<Space>`→`:nohlsearch` · `j/k`→`gj/gk` · `<leader>b`→`<C-^>`
   - Editing: ignorecase+smartcase · 2-space expandtab · scrolloff 3 · undofile · `noequalalways`
   - Display: restore last cursor position · `list` with `tab:▸ ,trail:·` (VS Code `renderWhitespace: trailing`) · no line numbers · Nord colors
   - Saving: trim trailing whitespace on save (not markdown, like VS Code) · autosave on InsertLeave/TextChanged/FocusLost (`files.autoSave`)
   - Misc: spell for markdown/gitcommit · chmod +x on `#!` files
   - File explorer: built-in netrw (no plugin). `,e` toggles a 30-column left tree sidebar (`:Lexplore`,
     `g:netrw_liststyle = 3`, `g:netrw_winsize = 30`, banner off), which is your old vimrc's tree style.
   - Dropped: pathogen, ctrlp, syntastic, sessions, quickfix-maximize, print-statement maps, Google blocks. Neovim ≥0.10 already has truecolor detection, `gc` commenting, the pbcopy clipboard, and `:Man`.
4. **Plugins (`vim.pack.add`), four in total:**
   - `ibhagwan/fzf-lua`, which also becomes the `vim.ui.select` UI
   - `EdenEast/nightfox.nvim` (`nordfox`)
   - `tpope/vim-surround` + `vim-repeat` (VSCodeVim emulates surround)

   No nvim-treesitter: markdown's tree-sitter parser ships inside Neovim, Python uses Neovim's built-in
   syntax file, and beancount colors come from the language server (step 6). Built-ins replace the rest:
   `vim.lsp.completion` + `'autocomplete'`, default statusline. Commit the lockfile.
5. **Cmd-P / Cmd-Shift-P**
   - `<D-p>` (fallback `<leader>p`) → `FzfLua.global()` with `formatter = 'path.filename_first'`.
     Prefixes: none = files, `$` = buffers, `@` = document symbols, `#` = workspace symbols.
   - `<D-S-p>`/`<D-P>` (fallback `<leader>P`) → `palette.lua`. It lists every keymap and user command that
     has a `desc` (global plus buffer-local, so beancount actions appear only in ledgers) and a few curated
     actions: find files, live grep, buffers, diagnostics list, format, toggle inlay hints, toggle spell.
     Rows show as `Title   <key>` through `vim.ui.select` and run the callback.
   - Stretch: add `{ 'commands', prefix = '>' }` to fzf-lua's `global.pickers` if it behaves.
6. **Beancount**
   - Highlighting comes only from beancount-language-server's semantic tokens, which Neovim applies
     automatically. Neovim ships no beancount syntax file.
     - At implementation, dump the server's token legend (`client.server_capabilities.semanticTokensProvider.legend`)
       and link any `@lsp.type.*.beancount` groups the colorscheme doesn't cover (dates, accounts,
       amounts, currencies, strings, comments, flags) to sensible groups.
     - Expect plain text for the moment before the server finishes its first parse.
     - If coverage turns out thin, the fallback is adding `nathangrigg/vim-beancount` (regex syntax; one
       plugin, no native code).
   - `after/ftplugin/beancount.lua` sets `commentstring=; %s`.
   - Errors and completion: `lsp/beancount.lua` (`cmd = {'beancount-language-server','--stdio'}`,
     `filetypes = {'beancount'}`; `before_init` sets `params.initializationOptions.journal_file` from
     `vim.g.beancount_main`), then `vim.lsp.enable{'beancount','beancount_outline'}`.
   - Diagnostics: `vim.diagnostic.config{ virtual_text = true, severity_sort = true }` (virtual text is off by
     default since 0.11). LspAttach turns on completion autotrigger and inlay hints, which show the implied
     balancing amount.
   - `vim.g.beancount_main` comes from a `.nvim.lua` in the ledger root (`exrc`, trusted once; 0.12 also
     searches parent dirs).
   - **Outline, mirroring your DocumentSymbolProvider.** `outline.lua` ports `levelFromLine`,
     `SymbolProvider` (nesting and ranges) and `symbolKind` (/statement/i → Constant, level ≤1 → Class,
     else Function). It serves them from an in-process LSP server (documented `cmd`-as-function pattern;
     answers `initialize`, `textDocument/documentSymbol`, `shutdown`). That gives you:
     - ⌘P then `@` lists headers hierarchically, as in VS Code.
     - A buffer-local `gO` opens a persistent outline as a 32-column left sidebar (a location list via
       `leftabove vertical lopen`). Names are indented by level, the `file|line|` columns are hidden via
       `quickfixtextfunc`, and it refreshes on save. Constants are left out (your `showConstants: false`).
     - A heading-level `foldexpr` from the same parser: `za`/`zM`/`zR`, `foldlevel=99`.
   - `:BeanDoctor [context|linked|region]` (`<leader>d`):
     - Runs `:update`, then `vim.system{'bean-doctor', sub, main, file..':'..line}` (range for region).
     - Output goes to a scratch tab named `<base>.context.<line>.beancount`. No filetype is set, so the
       LSP stays detached, which also means this tab is plain uncolored text.
     - Errors go to `vim.notify`.
   - `:BeanCalc` (`<leader>c`): sends the current line to `python3 python/beancalc.py`. The script ports
     `calculate()` exactly:
     - strip an old `= result`
     - posting with cost (`^\s+[\w:]+\s+([0-9.-]+)\s+\w+\s+\{([0-9.-]+)`) → amount × cost, with ` ;` appended
     - otherwise strip a leading `;` and evaluate `+ - * / ^ ( )` with jison precedence (unary minus
       tightest, `^` left-associative above `* /`), using `decimal.Decimal`
     - print `{"line","result"}` as JSON.

     Lua then replaces the line and runs `setreg('+', result)`.
7. **Markdown:** tree-sitter highlighting is on by default in 0.12 using the parser bundled with Neovim
   (no plugin), `gO` gives the built-in outline, and
   spell is on. `:MarkdownPreview` (`<leader>m`, your old binding) runs
   `pandoc -f gfm -s --metadata pagetitle=<name> -o <cache>/<name>.html %`, then `vim.ui.open()` (macOS `open`).
8. **Shell, git, iTerm2**
   - zshrc: `EDITOR=nvim`, `MANPAGER='nvim +Man!'` (replaces the VIMPAGER hack), `alias vim=nvim`. Bind the
     two escape sequences below to a no-op widget so ⌘P at a shell prompt doesn't type `2;9u`.
   - gitconfig: `core.editor = nvim`.
   - iTerm2: add these under Profiles → Keys → Key Mappings ("Send Escape Sequence"), then re-export the
     profile to `home_files/iterm-settings.json`:

     | Shortcut | Escape sequence | Neovim sees |
     |---|---|---|
     | ⌘P | `[112;9u` | `<D-p>` |
     | ⌘⇧P | `[112;10u` | `<D-S-p>` (also map `<D-P>`) |

     If ⌘P still opens iTerm2's Print, reassign that menu item under System Settings → Keyboard → App Shortcuts.
9. **Cleanup**
   - Delete `home_files/vimrc`, `home_files/gvimrc` and `setup_dot_vim.sh`.
   - `dotvim/README.md`: add "superseded by dotfiles/home_files/nvim" (you archive the repo on GitHub).
   - Keep `home_files/vscode/` and VS Code (with `chat.disableAIFeatures`) until you no longer need it.
   - `vscode-aaronsbeancountutils` is unchanged.

The implementation lands as a follow-up change in `dotfiles`, plus the README note in `dotvim`.

### Daily keys
⌘P quick open (`@` headers, `$` buffers) · ⌘⇧P palette · `gO` outline sidebar · `,e` file tree · `<leader>c` calc → clipboard ·
`<leader>d` bean-doctor · `]d`/`[d` next/prev error, `<C-w>d` full message (built-in) · `gcc` comment ·
`<leader>m` markdown → browser · `za`/`zM`/`zR` folds.

## Mouse and scrolling (in iTerm2)

**Mouse.** Your iTerm2 profile already has Mouse Reporting on, and Neovim's default `mouse=nvi` is kept
(your old vimrc used `mouse=n`). That gives you:
- click to place the cursor or focus a split
- drag to select (visual mode); double-click selects a word
- drag a split border or statusline to resize
- wheel/trackpad scrolls the split under the pointer, even if it isn't focused
- right-click menu (Go to definition / References when an LSP is attached)
- in fzf-lua pickers, scroll the list and click a row; double-click opens it
- clicks in the netrw tree and the outline sidebar

Copying with the mouse needs care:
- With reporting on, a drag makes a *Neovim* selection, so ⌘C copies nothing. Yank it to the macOS
  clipboard with `,y` (`"+y`, carried over from your old vimrc).
- Hold ⌥ while dragging to get iTerm2's own selection instead; ⌘C works then.

**Is it smooth scrolling? No, not like VS Code.** A terminal draws a fixed character grid, so every
scroll moves by whole lines. Nothing animates pixel by pixel. What the plan does about it:
- `mousescroll=ver:1,hor:2` (default is `ver:3`). A trackpad sends many small wheel events, so 1 line
  per event reads as a fairly continuous glide. It's still line-stepped. Tune to taste.
- `smoothscroll` on. Despite the name, this isn't animation: it lets a long *wrapped* line (common in
  markdown) scroll a screen row at a time instead of jumping past it.
- Keyboard jumps (`Ctrl-D`/`Ctrl-U`, `Ctrl-F`/`Ctrl-B`, `zz`) are instant. If you miss motion,
  `neoscroll.nvim` (one small plugin) animates them over ~150ms, still line by line. It's not in the
  default plugin list.
- No scrollbar. Your position shows in the statusline (`Top` / `42%` / `Bot`). fzf-lua's preview pane
  has its own scrollbar.
- Pixel-smooth scrolling is the one thing only a GUI (Neovide) can do; see "Do you need Neovide?".

## Security posture
Neovim's own CVEs have mostly been memory-safety bugs inherited from Vim. The real attack surfaces are
files that run code on open (modelines, `exrc`) and third-party plugins. So:
- `vim.o.modeline = false`. Your old vimrc already had `modelines=0`. Vim modeline-sandbox bypasses keep
  recurring (CVE-2019-12735, CVE-2026-34982), and Neovim's planned modeline trust prompt isn't done yet.
- `exrc` stays on only for the ledger's `.nvim.lua`. Neovim hashes it and asks you to `:trust` it, and asks
  again whenever the file changes.
- Keep the plugin list small: fzf-lua, nightfox, surround, repeat. None of them compiles native code. Pin them with the
  committed `nvim-pack-lock.json`. `vim.pack.update()` shows a confirm buffer of incoming changes before
  applying anything.
- Keep Neovim current via `brew upgrade neovim`. 0.12.5 already includes the 0.12.3 fix for the
  `vim.secure` trust-prompt "View" command injection (neovim#39914).
- fzf-lua has no published advisories and no SECURITY.md; it's maintained mostly by one person
  (ibhagwan). The risk is the same as any plugin: it runs as you and builds `rg`/`fd`/`git` command
  lines from your queries and filenames. Updates are pinned and reviewed through the lockfile.
- The `fzf` binary it drives has had advisories:
  - CVE-2026-53432/53433: denial of service, fixed in 0.73.1.
  - Two 2026-10-11 advisories, fixed in 0.74.5: one in the `fzf-tmux` script, one in the zsh completion
    script. Neither path is used here, but require `fzf >= 0.74.5` anyway and add `fzf` to
    `editor-versions.env` so Renovate flags new releases.

## Staying up to date (Neovim and the markdown parser)

Brew installs everything, so nothing in the repo records versions. The fix is a pin file that a bot
watches, plus one local script.

- **Pin file:** `dotfiles/editor-versions.env`. Each line has a bot comment, for example
  `# renovate: datasource=github-releases depName=neovim/neovim` above `NVIM_VERSION=0.12.5`. It covers:
  - Neovim
  - pandoc (the markdown → HTML renderer)
  - `tree-sitter-grammars/tree-sitter-markdown` (the highlighting parser; Neovim bundles it, so it's
    informational and arrives with Neovim upgrades)
  - beancount-language-server (now also your beancount highlighter) and fzf (minimum 0.74.5; see
    Security posture)
- **Bot: Renovate rather than Dependabot.** Dependabot only reads standard manifests (npm, pip, actions,
  docker, nix, …). It can't read a custom version file or Homebrew. Renovate (free GitHub App, one-click
  install on `dotfiles`) supports exactly this through a regex `customManagers` entry in `renovate.json`
  using the `github-releases` datasource. Use `extractVersion: "^v(?<version>.+)$"` so Neovim's
  `nightly`/`stable` tags are ignored and only `vX.Y.Z` releases count. You get:
  - a PR per new release, which bumps the pin and is your reminder
  - a pinned "Dependency Dashboard" issue listing everything outdated
  - a weekly schedule with grouped minor/patch updates

  Nothing builds or deploys, so merging a PR just records that you upgraded.
- **Dependabot's role:** none needed. If you'd rather avoid a third-party app, the alternative is a weekly
  GitHub Action (Python, `gh`) that compares the pins against the latest releases and opens an issue.
  Dependabot would then keep that workflow's actions current. Caveat: GitHub disables scheduled workflows
  after 60 days without commits, and this repo often goes months between commits.
- **Local script:** `dotfiles/editor-update`, on PATH via `~/bin`:
  - runs `brew upgrade neovim pandoc beancount-language-server fzf`
  - opens `nvim +"lua vim.pack.update()"` (review screen for plugin changes)
  - rewrites `editor-versions.env` from the installed versions and shows `git diff`

  Merge the Renovate PR or commit the diff, plus the updated `nvim-pack-lock.json`.
- **Plugins stay local:** they're tracked by `nvim-pack-lock.json` and `vim.pack.update()`. The bot
  doesn't watch them, which keeps PR noise down.

## Risks / gaps
- VS Code-only things in your settings (Jupyter, debugpy, Monkey C, CSV preview): keep VS Code around with
  AI disabled, or add nvim-dap later.
- Lencerf's hover-for-account-balance has no equivalent yet; it's planned in beancount-language-server.
- Beancount colors depend on the language server running. If it crashes, isn't on PATH, or its
  semantic-token coverage is thin, ledgers are plain text. Fallback is `nathangrigg/vim-beancount`
  regex syntax.
- Multi-file ledgers need `vim.g.beancount_main` set; otherwise diagnostics and completion are per-file.
- ⌘-mappings apply in every iTerm2 session using that profile (hence the zsh no-ops). tmux passthrough is untested.

## Verification
1. `python3 -m unittest discover -s home_files/nvim/python -v`: the 5 ported cases (`0.1 + 0.2 = 0.3`,
   re-calc, leading `;`, `10.673 VFIFXG {127.64 USD} ; = 1362.30172`), plus `2*3^2 = 18`, `-2^2 = 4`
   (jison precedence), division, and a non-zero exit on garbage.
2. In this container, install the nvim 0.12.5 release tarball, fzf, `pip install beancount`, `cargo install beancount-language-server` and pandoc (all reachable here).
   Headless start must show no errors; vim.pack must install plugins and write the lockfile;
   `:checkhealth vim.lsp vim.pack` must be clean.
3. `nvim -l tests/spec.lua` against the fixture ledger (`*`/`**` headers plus a "Statements" header) checks:
   - documentSymbol via `vim.lsp.buf_request_sync` (names, nesting, kinds)
   - `gO` filtering, fold levels, `:BeanCalc` rewrite and register
   - `:BeanDoctor` scratch buffer contents
   - LSP diagnostics on a deliberately broken fixture
   - semantic-token highlighting: `vim.lsp.semantic_tokens.get_at_pos` returns tokens for a date, an
     account and an amount, and every token type in the server's legend maps to a non-empty highlight group
   - `:MarkdownPreview` HTML (with `vim.ui.open` stubbed)
   - palette rows appear only in beancount buffers
4. pty test: start nvim in a pseudo-terminal, write `\x1b[112;9u`, and assert the `<D-p>` mapping fired.
   That covers the Neovim half of ⌘P.
5. Validate `renovate.json` (`npx --package renovate renovate-config-validator`). Run Renovate's regex
   locally (`LOG_LEVEL=debug npx renovate --platform=local --dry-run`) and confirm it detects all pins in
   `editor-versions.env`. Run `editor-update --dry-run` to confirm it prints installed vs pinned versions.
6. On your Mac, in iTerm2:
   - `:lua print(vim.fn.keytrans(vim.fn.getcharstr()))` then ⌘P prints `<D-p>`.
   - ⌘P then `@` shows headers.
   - Inline errors render.
   - Calc lands on the clipboard.
   - `,m` opens the browser.
