---
layout: page
lang: en
permalink: /
title: Andrea Esposito
image: /assets/images/profile.jpeg
description: >-
  Andrea Esposito is a Ph.D. student in the Department of Computer Science at the University of Bari Aldo Moro. He is an active member of the Interaction, Visualization, Usability & UX (IVU) Laboratory, where his research focuses on Human-Centred Artificial Intelligence. His interests lie in Human-Computer Interaction, eXplainable Artificial Intelligence, and Human-AI Interaction.
---

{{ site.data.curriculum.brief | markdownify }}

{% assign news = site.data.news | sort: 'date' | reverse %}
{% if news.size > 0 %}
## News

<ul class="list-unstyled news">
{% for item in news limit: 5 %}
  <li class="mb-2">
    <span class="text-muted">{{ item.date | date: "%b %-d, %Y" }}</span> &middot;
    <strong>{% if item.url %}<a href="{{ item.url }}">{{ item.title }}</a>{% else %}{{ item.title }}{% endif %}</strong>
    {% if item.description %}<div>{{ item.description | markdownify | remove: '<p>' | remove: '</p>' }}</div>{% endif %}
  </li>
{% endfor %}
</ul>
{% endif %}

{% assign highlights = site.data.highlights.highlights %}
{% if highlights.size > 0 %}
## Publication highlights

<style>
  /* The stretched "Details" link covers the whole card; interactive content stays above it. */
  .highlights .card { transition: border-color .15s, box-shadow .15s; }
  .highlights .card:hover { border-color: var(--bs-primary); box-shadow: var(--bs-box-shadow-sm); }
  .highlights .card a:not(.stretched-link), .highlights .card summary { position: relative; z-index: 2; }
  .highlights .card .bib-actions a.ms-auto { display: none; }
  .highlights .card-footer details > summary { width: fit-content; }
</style>
<div class="highlights">
{% for item in highlights %}
  {% capture paper_html %}{% bibliography --group_by none --query @*[key={{item.paper}}] %}{% endcapture %}
  {% capture details_url %}{% details_link {{item.paper}} %}{% endcapture %}
  {% capture card_header_open %}<article class="card position-relative"><div class="card-header" {% endcapture %}
  {% capture card_body %}</div><div class="card-body">{{ item.text | markdownify }}</div><div class="card-footer small d-flex flex-wrap align-items-baseline gap-2"><details>{% endcapture %}
  {% capture card_end %}</details><a href="{{ details_url | absolute_url }}" class="ms-auto stretched-link"><i class="fa-solid fa-circle-info fa-fw" aria-hidden="true"></i> Details</a></div>{% endcapture %}
  <div class="mb-4">
    {{ paper_html | replace: '<ol class="bibliography"><li>', '' | replace: '</li></ol>', '' | replace: '<article ', card_header_open | replace: '<details class="small mt-2 border-start border-3 ps-3">', card_body | replace: '</details>', card_end | edit_urls | remove_number | emphasize_author }}
  </div>
{% endfor %}
</div>
{% endif %}
