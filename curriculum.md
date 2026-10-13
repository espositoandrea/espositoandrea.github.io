---
layout: page
lang: en
permalink: /curriculum
title: "Curriculum"
image: /assets/images/profile.jpeg
description: >-
  Curriculum vitae of Andrea Esposito, PhD: postdoctoral researcher at Inria in the Wimmics team (Université Côte d'Azur), working on Human-Centered AI and Symbiotic AI at the intersection of Human-Computer Interaction and Artificial Intelligence. PhD in Computer Science and Mathematics from the University of Bari Aldo Moro.
---

{{ site.data.curriculum.brief | markdownify }}

## Memberships
<div class="list-group mb-12">
    {% for membership in site.data.curriculum.memberships %}
    <div class="list-group-item py-3 d-flex flex-column sm:flex-row justify-content-between sm:align-items-baseline gap-1 sm:gap-5">
        <div>
            <a class="fw-semibold" href="{{ membership.url }}" target="_blank" rel="noopener noreferrer">{{ membership.short }}</a>
            <span class="small fg-secondary d-block">{{ membership.institution }}</span>
        </div>
        <span class="small fg-secondary font-monospace text-nowrap">Since <time datetime="{{ membership.since | date: '%Y-%m' }}">{{ membership.since | date: "%b %Y" }}</time></span>
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
