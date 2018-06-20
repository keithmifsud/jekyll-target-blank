# Jekyll Target Blank

![Jekyll Target Blank Logo](assets/logo.png "Jekyll Target Blank")

Automatically adds a `target="_blank"` attribute to all __external__ links in Jekyll Content.

[![Gem Version](https://badge.fury.io/rb/jekyll-target-blank.svg)](https://badge.fury.io/rb/jekyll-target-blank)
[![Build Status](https://travis-ci.org/keithmifsud/jekyll-target-blank.svg?branch=master)](https://travis-ci.org/keithmifsud/jekyll-target-blank)

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

## Support

Simply [create an issue](https://github.com/keithmifsud/jekyll-target-blank/issues/new) and I will respond as soon as possible.

 
## Contributing

1. [Fork it](https://github.com/keithmifsud/jekyll-target-blank/fork)
2. Create your feature branch (`git checkout -b my-new-feature)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (git push origin my-new-feature)
4. Create a new Pull Request


### Testing

```bash
rake spec
# or
rspec
```

## Legal

This software is distributed under the [MIT](LICENSE.md) license.

&copy; 2018 - Keith Mifsud <https://keith-mifsud.me> and approved contributors.
