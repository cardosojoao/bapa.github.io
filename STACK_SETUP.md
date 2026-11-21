# Stack theme setup for bapa.one

This repository already contains Hugo Theme Stack as a Git submodule. Keep the existing repository and articles; a new Hugo site is not needed.

## 1. Prepare the site

Install Hugo Extended (this project is tested with version 0.164.0) and Git. In PowerShell:

```powershell
Set-Location D:\devl\site\bapa
hugo version
git submodule update --init --recursive
```

For a new checkout on another computer:

```powershell
git clone --recurse-submodules https://github.com/cardosojoao/bapa.git
Set-Location bapa
```

Do not run `hugo new site` inside this existing site or add the same theme submodule again.

## 2. Configure the theme

| File | Purpose |
| --- | --- |
| `hugo.toml` | Domain, theme, language selection, pagination, and article URLs |
| `config/_default/languages.toml` | English title and sidebar description |
| `config/_default/params.toml` | Avatar, widgets, article settings, and comments |
| `config/_default/menu.toml` | Social links |
| `config/_default/markup.toml` | Markdown and code highlighting |
| `assets/scss/custom.scss` | Your custom styles |

The main settings are:

```toml
baseURL = "https://bapa.one/"
locale = "en-us"
title = "Bapa"
theme = "hugo-theme-stack"
defaultContentLanguage = "en"
disableLanguages = ["zh", "zh-hant-tw", "ja"]
```

Edit the configuration under `config/_default`, rather than the extra copies named `languages.toml`, `params.toml`, and `menu.toml` in the project root. Hugo's split configuration uses the files under `config/_default`.

Keep theme customizations in the site's own configuration, assets, and layouts so that theme updates do not overwrite them. Comments are disabled until you configure your own provider. The translated content files remain available, but their languages are disabled.

## 3. Preview locally

```powershell
hugo server -D
```

Open the localhost URL printed by Hugo, normally http://localhost:1313/. Press Ctrl+C to stop. The `-D` option includes draft articles in this preview.

## 4. Create an article

```powershell
hugo new content post/my-new-post/index.md
```

Edit `content/post/my-new-post/index.md`, change the title, set `draft = false` when ready to publish, and write below the front matter. Put article images in the same directory. Your existing six articles and their URLs are preserved.

## 5. Build for publication

```powershell
hugo --minify --environment production --cleanDestinationDir
```

This writes the site to `public`. That directory is generated output: keep original content and images under `content` or `assets`. The clean destination option removes old output that no longer belongs to the current site.

## 6. Configure GitHub Pages

In https://github.com/cardosojoao/bapa/settings/pages:

1. Set the publishing source to **GitHub Actions**.
2. Set the custom domain to **bapa.one** and save.
3. Keep the existing DNS records pointing to GitHub Pages.
4. Enable **Enforce HTTPS** when available.

The workflow in `.github/workflows/hugo.yml` runs on pushes to `main`. After committing and pushing your intended changes, check **Actions > Deploy Hugo** for a successful deployment. You can also run it manually using **Run workflow** once the updated workflow is on GitHub.

An Actions deployment does not require a CNAME file. Configuring the theme locally does not change the GitHub repository's Pages settings or publish the site.
