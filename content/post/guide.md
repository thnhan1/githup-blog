---
title: "Complete Guide using github-style hugo template"

date: 2025-02-18T6:10:47+07:00
draft: false
pin: false
---

# Guide using Github-Style hugo template

## Main readme
Edit `content/readme.md` or create one if it does not exist.

<!--more-->

```bash
hugo new readme.md
```

## Config Post

### Add new post

```bash
hugo new posts/title_of_post.md
```
### Pin post

```
---
pin: true
---
```

### Limit display content
- Use Summary
```
---
title: "title"
date: 2019-10-22T18:46:47+08:00
draft: false
summary: "The summary content"
---
```
- Use `<!--more-->`

```---
title: "title"
date: 2019-10-22T18:46:47+08:00
draft: false
---
abstraction show in the post page
<!--more-->
other content
```

### Add last modified date

```toml
lastmod = true
[frontmatter]
    lastmod = ["lastmod", ":fileModTime", ":default"]
```

### enable comment with gittalk
Using app id of github + git issue
```toml
enableGitalk = true

  [params.gitalk]
    clientID = "Your client ID"
    clientSecret = "Your client secret"
    repo = "repo"
    owner = "Your Github username"
    admin = "Your Github username"
    id = "location.pathname"
    labels = "gitalk"
    perPage = 30
    pagerDirection = "last"
    createIssueManually = true
    distractionFreeMode = false
```

### Support latex
add `math: true` to front matter
```
---
katex: math
---
```
Using katex script:
```
# replace ... with latex formula
display inline \\( ... \\)
display block $$ ... $$
```

## Custom CSS and JS
static folder and config folder in `hugo.toml`
```
[params]
  custom_css = ["css/custom.css"]
  custom_js = ["js/custom.js"]
```

## hugo.toml example
```toml
baseURL = "https://meik2333.com/"
languageCode = "zh-cn"
title = "MeiK's blog"
theme = "github-style"
pygmentsCodeFences = true
pygmentsUseClasses = true

[params]
  author = "MeiK"
  description = "In solitude, where we are least alone."
  github = "MeiK2333"
  facebook = "MeiK2333"
  twitter = "MeiK2333"
  linkedin = "MeiK2333"
  instagram = "MeiK2333"
  tumblr = "MeiK2333"
  email = "meik2333@gmail.com"
  url = "https://meik2333.com"
  keywords = "blog, google analytics"
  rss = true
  lastmod = true
  userStatusEmoji = "😀"
  favicon = "/images/github.png"
  avatar = "/images/avatar.png"
  headerIcon = "/images/GitHub-Mark-Light-32px.png"
  location = "China"
  enableGitalk = true
  custom_css = ["css/custom.css"]
  custom_js = ["js/custom.js"]

  [params.gitalk]
    clientID = "Your client ID"
    clientSecret = "Your client secret"
    repo = "repo"
    owner = "MeiK2333"
    admin = "MeiK2333"
    id = "location.pathname"
    labels = "gitalk"
    perPage = 15
    pagerDirection = "last"
    createIssueManually = true
    distractionFreeMode = false

  [[params.links]]
    title = "Link"
    href = "https://github.com/meik2333"
  [[params.links]]
    title = "Link2"
    href = "https://meik2333.com"
    icon = "https://meik2333.com/images/avatar.png"

[frontmatter]
  lastmod = ["lastmod", ":fileModTime", ":default"]

[services]
  [services.googleAnalytics]
    ID = "UA-123456-789"

```

## Collapsible block
```
{{<details "summary title">}}

block content

{{</details>}}
```

## Local Search
config `hugo.toml`
```toml
[params]
  enableSearch = true

[outputs]
  home = ["html", "json"]

[outputFormats.json]
  mediaType = "application/json"
  baseName = "index"
  isPlainText = false
```

## Deploy.sh example

```sh
#!/bin/sh

if [ "`git status -s`" ]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
env HUGO_ENV="production" hugo -t github-style

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"

#echo "Pushing to github"
#git push --all
```