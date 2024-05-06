---
layout: default
lang: en
permalink: /index.html
title: "Andrea Esposito"
---

## Curriculum

{{ site.data.curriculum.brief | markdownify }}

He is a member of:
{% for membership in site.data.curriculum.memberships %}
- [{{ membership.short }}]({{ membership.url }}){: target="_blank" } ({{ membership.institution }}) since {{ membership.since | date: "%B %Y" }}
{% endfor %}

## Experience
<ul>
    {% for edu in site.data.curriculum.experiences %}
    {%- capture end_date -%}
    {% if edu.years.end != nil %}
    {{ edu.years.end | date: "%b %Y" }}
    {% else %}
    Present
    {% endif %}
    {%- endcapture -%}

    <li>
        <strong>{{ edu.title | smartify }}</strong>
        ({{ edu.years.start | date: "%b %Y" }}
        &ndash;
        {{ end_date | strip }}),
        <em>
            {% if edu.institute.url %}
            <a target="_blank" href="{{ edu.institute.url }}">{{ edu.institute.name | smartify }}</a>
            {% else %}
            {{ edu.institute | smartify }}
            {% endif %}
            ({{ edu.location | smartify }})</em>.
        <div>
            {% if edu.notes %}
            {{ edu.notes | markdownify }}
            {% endif %}
        </div>
    </li>
    {% endfor %}
</ul>

## Education
<ul>
    {% for edu in site.data.curriculum.education %}
    {%- capture end_date -%}
    {% if edu.years.end != nil %}
    {{ edu.years.end | date: "%b %Y" }}
    {% else %}
    Present
    {% endif %}
    {%- endcapture -%}

    <li>
        <strong>{{ edu.title | smartify }}</strong>
        ({{ edu.years.start | date: "%b %Y" }}
        &ndash;
        {{ end_date | strip }}),
        <em>
            {% if edu.institute.url %}
            <a target="_blank" href="{{ edu.institute.url }}">{{ edu.institute.name | smartify }}</a>
            {% else %}
            {{ edu.institute | smartify }}
            {% endif %}
            ({{ edu.location | smartify }})</em>.
        <div>
            {% if edu.notes %}
            {{ edu.notes | markdownify }}
            {% endif %}
        </div>
    </li>
    {% endfor %}
</ul>

{% comment %} {% include awards.html %} {% endcomment %}
{% comment %} {% include skills.html %} {% endcomment %}

{% include publications.html %}

## Projects

Here is a list of some of the _open-source_ projects on which I
worked. In the following list are presented both personal projects and
projects published under third-party organizations.

{% repositories site.data.repos_data %}

{% comment %} {% include posts.html %} {% endcomment %}
