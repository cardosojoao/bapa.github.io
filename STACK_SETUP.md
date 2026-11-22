# Stack theme setup for bapa.one

This repository contains Hugo Theme Stack as regular files in `themes/hugo-theme-stack`. Keep the existing repository and articles; a new Hugo site is not needed. No Git submodule setup is required.

For an existing checkout that still tracks the theme as a submodule, run the one-time conversion from a local PowerShell session:

```powershell
.\scripts\Convert-StackTheme.ps1
```

This keeps the current theme files and stages them with the workflow and guide updates. Review the staged changes, then commit and push to publish the conversion. The old submodule history under `.git/modules` is left in place.

## 1. Prepare the site

Install Hugo Extended (this project is tested with version 0.164.0) and Git. In PowerShell:

```powershell
Set-Location D:\devl\site\bapa
hugo version
```

For a new checkout on another computer:

```powershell
git clone https://github.com/cardosojoao/bapa.git
Set-Location bapa
```

Do not run `hugo new site` inside this existing site or add the theme as a submodule.

## 2. Configure the theme

| File | Purpose |
| --- | --- |
| `hugo.toml` | Domain, theme, language selection, pagination, and article URLs |
| `config/_default/languages.toml` | English title and sidebar description |
| `config/_default/params.toml` | Avatar, widgets, article settings, and comments |
| `config/_default/menu.toml` | Social links |
| `config/_default/markup.toml` | Markdown and code highlighting |
| `assets/scss/custom.scss` (optional) | Create this file to add custom styles |

The main settings are:

```toml
baseURL = "https://bapa.one/"
locale = "en-us"
title = "Bapa"
theme = "hugo-theme-stack"
defaultContentLanguage = "en"
```

Edit the split configuration under `config/_default`. The unused configuration copies in the project root have been removed.

Keep theme customizations in the site's own configuration, assets, and layouts so that theme updates do not overwrite them. Comments are disabled until you configure your own provider. The site uses English only; translated demo content, the sample Links page, and the Documentation demo category have been removed. The About page at `content/page/about/index.md` introduces the author and the projects behind bapa.one. The theme files are versioned directly in this repository, including the upstream license. Theme updates must be applied manually and reviewed against the local cleanup and customizations.

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

The `.gitignore` excludes newly generated output and caches. Files already tracked in Git remain tracked until they are explicitly removed from the Git index.

## 6. Configure GitHub Pages

In https://github.com/cardosojoao/bapa/settings/pages:

1. Set the publishing source to **GitHub Actions**.
2. Set the custom domain to **bapa.one** and save.
3. Keep the existing DNS records pointing to GitHub Pages.
4. Enable **Enforce HTTPS** when available.

The workflow in `.github/workflows/hugo.yml` runs on pushes to `main`. After committing and pushing your intended changes, check **Actions > Deploy Hugo** for a successful deployment. You can also run it manually using **Run workflow** once the updated workflow is on GitHub.

An Actions deployment does not require a CNAME file. Configuring the theme locally does not change the GitHub repository's Pages settings or publish the site.
