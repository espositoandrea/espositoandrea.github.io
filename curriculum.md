---
schema_type: ProfilePage
layout: page
lang: en
permalink: /curriculum
title: "Curriculum"
image: /assets/images/profile.jpeg
description: >-
  Curriculum vitae of Andrea Esposito, PhD: postdoctoral researcher at Inria in the Wimmics team (Université Côte d'Azur), working on Human-Centered AI and Symbiotic AI at the intersection of Human-Computer Interaction and Artificial Intelligence. PhD in Computer Science and Mathematics from the University of Bari Aldo Moro.
---

<div itemprop="description">
{{ site.data.curriculum.brief | markdownify }}
</div>

## Memberships
<div class="list-group mb-12">
    {% for membership in site.data.curriculum.memberships %}
    <div class="list-group-item py-3 d-flex flex-column sm:flex-row justify-content-between sm:align-items-baseline gap-1 sm:gap-5"
        itemprop="memberOf" itemscope itemtype="https://schema.org/OrganizationRole">
        <div itemprop="memberOf" itemscope itemtype="https://schema.org/Organization">
            <a class="fw-semibold" href="{{ membership.url }}" target="_blank" rel="noopener noreferrer" itemprop="url"><span itemprop="alternateName">{{ membership.short }}</span></a>
            <span class="small fg-secondary d-block" itemprop="name">{{ membership.institution }}</span>
        </div>
        <span class="small fg-secondary font-monospace text-nowrap">Since <time itemprop="startDate" datetime="{{ membership.since | date: '%Y-%m' }}">{{ membership.since | date: "%b %Y" }}</time></span>
    </div>
    {% endfor %}
</div>

## Experience
{% include cv-entries.html entries=site.data.curriculum.experiences icon="briefcase" property="worksFor" role="EmployeeRole" organization="Organization" %}

## Education
{% include cv-entries.html entries=site.data.curriculum.education icon="graduation-cap" property="alumniOf" role="OrganizationRole" organization="EducationalOrganization" %}

{% comment %} {% include awards.html %} {% endcomment %}
{% comment %} {% include skills.html %} {% endcomment %}

{% comment %} {% include posts.html %} {% endcomment %}
