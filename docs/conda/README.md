---
sort: 5
---

# Conda environments

## static

List all the yaml files in the current directory via jekyll

{for file in site.static_files}
{% include list.liquid %}
{/for}

## liquid

{% include list.liquid %}