# Jekyll Target Blank

Adds a `target="_blank"` to __external__ links in Jekyll Content.

[![Gem Version](https://badge.fury.io/rb/jekyll-target-blank.svg)](https://badge.fury.io/rb/jekyll-target-blank)

## Installation

Add the following to your site's `Gemfile`

```
gem 'jekyll-target-blank'
```

And add the following to your site's `_config.yml`

```yml
plugins:
  - jekyll-target-blank
```

Note: if `jekyll --version` is less than `3.5` use:

```yml
gems:
  - jekyll-target-blank
```

## Usage

All anchor tags and markdown links pointing to an external host, other than the one listed as `url` in jekyll's `_config.yml` will automatically open in a new tab once the site has been generated.

This includes pages, posts and collections. __Plain text links are not included__.

### Examples

#### HTML

The following html anchor tag:

```html
<a href="https://google.com">Google</a>
```

will be replaced with:

```html
<a href="https://google.com" target="_blank">Google</a>
```

..unless your website's URL is google.com 😉

#### Markdown

```markdown
[Google](https://google.com)
```

will be generated as:

```html
<a href="https://google.com" target="_blank">Google</a>
```
 
## Legal

This software is open sourced under the [MIT](LICENSE.md) license.

&copy; 2018 - Keith Mifsud <mifsud.k@gmail> and approved contributors.

## Dev Tasks - temp

- [ ] Update THIS, include;
    - [ ] Include contrib notes
    - [ ] add travis build badge

- [ ] Deploy to rubygems as version 1.0
- [ ] Deploy to GH and tag version + release.
    
- [ ] remove old version from rubygems add ignore from local.

- [ ] Submit to Jekyll's plugin list.
