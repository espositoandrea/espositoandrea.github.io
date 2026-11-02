---
schema_type: ProfilePage
layout: page
section: curriculum
lang: en
permalink: /curriculum
title: "Curriculum"
image: /assets/images/profile.jpeg
description: >-
  Curriculum vitae of Andrea Esposito, PhD: postdoctoral researcher at Inria in the Wimmics team (Université Côte d'Azur), working on Human-Centered AI and Symbiotic AI at the intersection of Human-Computer Interaction and Artificial Intelligence. PhD in Computer Science and Mathematics from the University of Bari Aldo Moro.
---
{%- assign cv = site.data.curriculum -%}

<div class="cv-grid">
<aside class="cv-card" aria-label="Affiliation and contacts">
    <img class="cv-photo" src="{{ site.author.picture | relative_url }}" alt="" width="160" height="160">
    <p class="cv-name">{{ site.author.name }}, {{ cv.title }}</p>
    <p class="cv-role">{{ cv.position | smartify }}</p>
    <ul class="cv-links">
        {%- assign cv_units = "laboratory,department,institution" | split: "," %}
        {%- for unit in cv_units %}
        {%- assign org = cv.affiliation[unit] %}
        <li><i class="fa-solid {% case unit %}{% when 'laboratory' %}fa-people-group{% when 'department' %}fa-building{% else %}fa-building-columns{% endcase %} fa-fw" aria-hidden="true"></i><a href="{{ org.url }}" target="_blank" rel="noopener noreferrer">{{ org.name | smartify }}</a></li>
        {%- endfor %}
        <li><i class="fa-regular fa-envelope fa-fw" aria-hidden="true"></i><a href="mailto:{{ site.author.mail | uri_escape }}">{{ site.author.mail }}</a></li>
    </ul>
    <ul class="cv-links no-blank-icon">
        {%- for contact in site.data.contacts %}
        <li><i class="{{ contact.icon }} fa-fw" aria-hidden="true"></i><a href="{{ contact.link }}" target="_blank" rel="me noopener noreferrer">{{ contact.value | default: contact.name }}</a></li>
        {%- endfor %}
    </ul>
</aside>

<div class="cv-main">
<div class="rich-text cv-brief" itemprop="description">
{{ cv.brief | markdownify }}
</div>

<section class="page-section" aria-labelledby="experience">
<div class="section-head"><h2 id="experience">Experience</h2></div>
{% include cv-entries.html entries=cv.experiences icon="briefcase" property="worksFor" role="EmployeeRole" organization="Organization" %}
</section>

<section class="page-section" aria-labelledby="teaching">
<div class="section-head"><h2 id="teaching">Teaching</h2></div>
{%- comment -%} The courses are the pages of the teachings collection: their front matter is the source of truth. {%- endcomment %}
{% assign courses = site.teachings | sort: "academicYear" | reverse %}
<ol class="timeline">
    {% for course in courses %}
    <li class="timeline-item{% unless course.period.end %} is-current{% endunless %}">
        <p class="timeline-when">
            <time datetime="{{ course.period.start | date: '%Y-%m' }}">{{ course.period.start | date: "%b %Y" }}</time>
            &ndash;
            {% if course.period.end %}<time datetime="{{ course.period.end | date: '%Y-%m' }}">{{ course.period.end | date: "%b %Y" }}</time>{% else %}<span class="timeline-now">Present</span>{% endif %}
        </p>
        <div class="timeline-body">
            <h3 class="timeline-title">{{ course.role | default: "Main Lecturer" }}: <a href="{{ course.url | relative_url }}">{{ course.titleTranslation | default: course.title | smartify }}</a></h3>
            <ul class="entry-facts">
                <li>
                    <i class="fa-solid fa-graduation-cap fa-fw" aria-hidden="true"></i>
                    {{ course.levelTranslation | default: course.level }} in {{ course.degreeTranslation | default: course.degree }}
                </li>
                <li>
                    <i class="fa-solid fa-building-columns fa-fw" aria-hidden="true"></i>
                    {{ course.institution.name }} &middot; {{ course.institution.department }}
                </li>
            </ul>
        </div>
    </li>
    {% endfor %}
</ol>
</section>

{%- if cv.subject_expert %}
<section class="page-section" aria-labelledby="subject-expert">
<div class="section-head"><h2 id="subject-expert">Subject-matter expert</h2></div>
<p class="entry-text">{{ cv.subject_expert.institution | smartify }}</p>
<ul class="entry-list">
    {%- for a in cv.subject_expert.appointments %}
    <li class="entry">
        <div class="entry-main">
            <div class="entry-head">
                <span class="entry-title">{{ a.course | smartify }}</span>
                <span class="meta text-nowrap">Since <time datetime="{{ a.since | date: '%Y-%m-%d' }}">{{ a.since | date: "%b %-d, %Y" }}</time></span>
            </div>
            <p class="entry-text">Sector {{ a.sector }}</p>
        </div>
    </li>
    {%- endfor %}
</ul>
</section>
{%- endif %}

<section class="page-section" aria-labelledby="education">
<div class="section-head"><h2 id="education">Education</h2></div>
{% include cv-entries.html entries=cv.education icon="graduation-cap" property="alumniOf" role="OrganizationRole" organization="EducationalOrganization" %}
</section>

<section class="page-section" aria-labelledby="memberships">
<div class="section-head"><h2 id="memberships">Memberships</h2></div>
<ul class="entry-list">
    {% for membership in cv.memberships %}
    <li class="entry" itemprop="memberOf" itemscope itemtype="https://schema.org/OrganizationRole">
        <div class="entry-main" itemprop="memberOf" itemscope itemtype="https://schema.org/Organization">
            <div class="entry-head">
                <a class="entry-title" href="{{ membership.url }}" target="_blank" rel="noopener noreferrer" itemprop="url"><span itemprop="alternateName">{{ membership.short }}</span></a>
                <span class="meta text-nowrap">Since <time itemprop="startDate" datetime="{{ membership.since | date: '%Y-%m' }}">{{ membership.since | date: "%b %Y" }}</time></span>
            </div>
            <p class="entry-text" itemprop="name">{{ membership.institution }}</p>
        </div>
    </li>
    {% endfor %}
</ul>
</section>
<section class="page-section" aria-labelledby="events">
<div class="section-head"><h2 id="events">Organisation of scientific events</h2></div>
{%- assign event_groups = "conferences,workshops" | split: "," %}
<ul class="entry-list">
    {%- for group in event_groups %}
    {%- for ev in site.data.events[group] %}
    <li class="entry"><div class="entry-main">
        <div class="entry-head">
            <a class="entry-title" href="{{ ev.link }}" target="_blank" rel="noopener noreferrer">{{ ev.title | smartify }}</a>
            <span class="meta text-nowrap">
                {%- if ev.start == ev.end %}{{ ev.start | date: "%b %-d, %Y" }}{% else %}{{ ev.start | date: "%b %-d" }} &ndash; {{ ev.end | date: "%b %-d, %Y" }}{% endif -%}
            </span>
        </div>
        <p class="entry-text">{{ ev.position }}{% if ev.event %}, workshop at {{ ev.event | smartify }}{% endif %}
            {%- if ev.paper %} &middot; <a href="{% details_link {{ev.paper}} %}">Workshop proposal</a>{% endif %}</p>
    </div></li>
    {%- endfor %}
    {%- endfor %}
</ul>
</section>

<section class="page-section" aria-labelledby="outreach">
<div class="section-head"><h2 id="outreach">Outreach and volunteering</h2></div>
<ol class="timeline">
    {%- for item in site.data.outreach %}
    <li class="timeline-item">
        <p class="timeline-when">
            {%- if item.start == item.end %}<time datetime="{{ item.start | date: '%Y-%m-%d' }}">{{ item.start | date: "%b %-d, %Y" }}</time>
            {%- else %}<time datetime="{{ item.start | date: '%Y-%m-%d' }}">{{ item.start | date: "%b %-d" }}</time> &ndash; <time datetime="{{ item.end | date: '%Y-%m-%d' }}">{{ item.end | date: "%b %-d, %Y" }}</time>{% endif -%}
        </p>
        <div class="timeline-body">
            <h3 class="timeline-title">{{ item.title | smartify }}</h3>
            <ul class="entry-facts">
                <li><i class="fa-solid fa-location-dot fa-fw" aria-hidden="true"></i> {{ item.location | smartify }}</li>
            </ul>
            <div class="entry-text">{{ item.notes | markdownify }}</div>
        </div>
    </li>
    {%- endfor %}
</ol>
</section>

<section class="page-section" aria-labelledby="languages">
<div class="section-head"><h2 id="languages">Languages</h2></div>
<ul class="entry-list">
    {%- for entry in site.data.languages %}
    {%- assign lang = entry[1] %}
    <li class="entry"><div class="entry-main">
        <div class="entry-head">
            <span class="entry-title">{{ lang.name.en }}</span>
            <span class="meta">{{ lang.level.en }}</span>
        </div>
        {%- if lang.cefr %}
        <p class="entry-text">CEFR levels: listening {{ lang.cefr.listening }}, reading {{ lang.cefr.reading }}, comprehension {{ lang.cefr.comprehension }}, oral production {{ lang.cefr.oralProduction }}, oral interaction {{ lang.cefr.oralInteraction }}.</p>
        {%- endif %}
    </div></li>
    {%- endfor %}
</ul>
</section>
</div>
</div>

{% comment %} {% include awards.html %} {% endcomment %}
{% comment %} {% include skills.html %} {% endcomment %}
