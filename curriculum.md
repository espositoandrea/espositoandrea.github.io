---
layout: page
lang: en
permalink: /curriculum
title: "Curriculum"
image: /assets/images/profile.jpeg
description: >-
  Andrea Esposito is a Ph.D. student in the Department of Computer Science at the University of Bari Aldo Moro. He is an active member of the Interaction, Visualization, Usability & UX (IVU) Laboratory, where his research focuses on Human-Centred Artificial Intelligence. His interests lie in Human-Computer Interaction, eXplainable Artificial Intelligence, and Human-AI Interaction.
---

{{ site.data.curriculum.brief | markdownify }}

## Memberships
<div class="list-group mb-5">
    {% for membership in site.data.curriculum.memberships %}
    <div class="list-group-item py-2 d-flex flex-column flex-sm-row justify-content-between align-items-sm-baseline gap-1 gap-sm-3">
        <div>
            <a class="fw-semibold" href="{{ membership.url }}" target="_blank" rel="noopener noreferrer">{{ membership.short }}</a>
            <span class="small text-body-secondary d-block">{{ membership.institution }}</span>
        </div>
        <span class="small text-body-secondary font-monospace text-nowrap">Since <time datetime="{{ membership.since | date: '%Y-%m' }}">{{ membership.since | date: "%b %Y" }}</time></span>
    </div>
    {% endfor %}
</div>

## Experience
{% include cv-entries.html entries=site.data.curriculum.experiences icon="briefcase" %}

## Education
{% include cv-entries.html entries=site.data.curriculum.education icon="graduation-cap" %}

{% comment %} {% include awards.html %} {% endcomment %}
{% comment %} {% include skills.html %} {% endcomment %}

{% comment %} {% include posts.html %} {% endcomment %}
