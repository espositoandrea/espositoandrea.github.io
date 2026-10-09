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

<div class="highlights">
{% for item in highlights %}
  {% capture paper_html %}{% bibliography --group_by none --query @*[key={{item.paper}}] %}{% endcapture %}
  {% capture card_body %}<div class="card-body"><div class="mb-3">{{ item.text | markdownify }}</div>{% endcapture %}
  {{ paper_html | replace: '<div class="card-body">', card_body | edit_urls | remove_number | emphasize_author }}
{% endfor %}
</div>
{% endif %}
