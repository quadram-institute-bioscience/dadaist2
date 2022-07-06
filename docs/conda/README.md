---
sort: 5
---

# Conda environments

## static

List all the yaml files in the current directory via jekyll

{% loop_directory directory:. iterator:file filter:*.yaml sort:descending %}
* [{{ file }}]({{ file }})
{% endloop_directory %}
