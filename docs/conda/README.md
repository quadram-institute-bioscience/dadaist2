---
sort: 5
---

# Conda environments

## static

List all the yaml files in the current directory via jekyll

<ul>
{% for member in site.data.members %}
  <li>
    <a href="https://github.com/{{ member.github }}">
      {{ member.name }}
    </a>
  </li>
{% endfor %}
</ul>