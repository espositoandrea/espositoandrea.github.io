---
layout: page
lang: en
permalink: /index.html
title: "Andrea Esposito"
image: /assets/images/profile.jpeg
description: >-
  Andrea Esposito is a Ph.D. student in the Department of Computer Science at the University of Bari Aldo Moro. He is an active member of the Interaction, Visualization, Usability & UX (IVU) Laboratory, where his research focuses on Human-Centred Artificial Intelligence. His interests lie in Human-Computer Interaction, eXplainable Artificial Intelligence, and Human-AI Interaction.
---

{{ site.data.curriculum.brief | markdownify }}

He is a member of:
{% for membership in site.data.curriculum.memberships %}
- [{{ membership.short }}]({{ membership.url }}){: target="_blank" } ({{ membership.institution }}) since {{ membership.since | date: "%B %Y" }}
{% endfor %}
