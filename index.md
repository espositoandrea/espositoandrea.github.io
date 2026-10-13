---
schema_type: ProfilePage
layout: page
lang: en
permalink: /
title: Andrea Esposito
image: /assets/images/profile.jpeg
description: >-
  Andrea Esposito is a postdoctoral researcher at Inria, in the Wimmics team at Université Côte d'Azur. He works on Human-Centered AI and Symbiotic AI, at the intersection of Human-Computer Interaction and Artificial Intelligence.
---

Hi, I'm Andrea! I'm a postdoctoral researcher at [Inria](https://www.inria.fr/){:target="_blank"},
in the [Wimmics](https://team.inria.fr/wimmics/){:target="_blank"} team at
[Université Côte d'Azur](https://univ-cotedazur.fr/){:target="_blank"}.
I study how people and AI systems can work *together*: I'm interested in AI
that augments human abilities rather than replacing them, and that people
can understand, question, and trust.
{: itemprop="description"}


Before moving to France, I earned my PhD in Computer Science and Mathematics at
the [University of Bari Aldo Moro](https://www.uniba.it/){:target="_blank"}.
Today I'm building LLM-based conversational assistants that help scientists
explore metabolomics knowledge graphs.

If you want the full story, have a look at my [curriculum]({{ '/curriculum' | relative_url }})
or my [publications]({{ '/publications' | relative_url }}).

## Research interests

- **Human-Centered and Symbiotic AI**: designing AI systems that augment people
  instead of replacing them, keeping humans in control.
- **Explainable AI**: making the behavior of AI models understandable to the
  people who rely on them.
- **Human-AI Interaction**: studying how people perceive, use, and trust AI,
  including the mental models they build of it.
- **Conversational AI and Knowledge Graphs**: LLM-based assistants that make
  complex scientific knowledge accessible through natural language.
- **Usability, UX, and Accessibility**: evaluating and improving interactive
  systems so that they work well for everyone.

{% assign news = site.data.news | sort: 'date' | reverse %}
{% if news.size > 0 %}
## News

<ul class="list-unstyled news">
{% for item in news limit: 5 %}
  <li class="mb-3">
    <span class="fg-secondary">{{ item.date | date: "%b %-d, %Y" }}</span> &middot;
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
  {% capture card_body %}<div class="card-body"><div class="mb-5">{{ item.text | markdownify }}</div>{% endcapture %}
  {{ paper_html | replace: '<div class="card-body">', card_body | edit_urls | remove_number | emphasize_author }}
{% endfor %}
</div>
{% endif %}

## Beyond research

When I'm not doing research, you'll probably find me with a camera in my hands.
Photography is one of my greatest passions: I love wandering around a city
looking for street and architectural shots, and trying to see familiar places
under a new light.
{%- assign instagram = site.data.contacts | where: "name", "Instagram" | first %}
{%- if instagram %}
You can find some of my photos on
[Instagram]({{ instagram.link }}){:target="_blank" rel="noopener noreferrer"}.
{%- endif %}
Sometimes, I also post them in my [blog]({{ '/blog/' | absolute_url }}) or on [Substack](https://espositoandrea.substack.com){:target="_blank" rel="noopener noreferrer"}.

I'm also a strong supporter of [free (as in "libre") software](https://www.gnu.org/philosophy/free-sw.html){:target="_blank"}:
software that respects its users' freedom to run, study, share, and improve it.
That's why my projects, configuration files, and even the source code of this
website are freely available on [GitHub](https://github.com/espositoandrea){:target="_blank"}.
