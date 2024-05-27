---
layout: post
title: To Automate or To Augment Humans? That is the Question for AI, and The Answer Depends on Users’ Requirements
image: /assets/images/posts/scirep-serene/cover.jpg
lang: en
category: Paper Summaries
tags: [ai, hcai, user experience, detection, user study, hci]
excerpt: >-
    The growing influence of AI brings benefits and risks. Our research explores how human-centred AI balances automation and human control in website usability evaluation. It shows how AI streamlines the detection of critical usability issues while augmented approaches also uncover less severe issues.
canonical_url: 'https://communities.springernature.com/posts/to-automate-or-to-augment-humans-that-is-the-question-for-ai'
canonical_site_name: Springer Nature Research Communities
paper: Esposito2024Fine
date: 2024-05-02T16:00+0002
---

<figure class="figure">
<img class="img-fluid figure-img" src="{% link assets/images/posts/scirep-serene/visual-abstract.png %}" title="Visual abstract" alt="A visual abstract for the manuscript titled “The fine line between automation and augmentation in website usability evaluation.” It feature the title of the paper on top, while the journal logo, authors, and DOI are at the bottom. The main section is subdivided in three columns, titled (from left to right) “Context”, “Method”, and “Results”. The context is the one of usability evaluations, and shows a set of users that tip the scale of automation vs augmentation through the context of use and their goals. The methods show a set of 99 participants, divided into different conditions that allowed to collect data that were then analysed. The results show that automation and augmentation have different benefits and drawbacks, and selection depends on the goal. More granular details on the results are provided in the visual abstract, but cannot be reported in this description due to space reasons." />
<figcaption class="figure-caption">Visual abstract</figcaption>
</figure>

{:style="text-align:center"}
Read the open access paper on [Scientific Reports](https://doi.org/10.1038/s41598-024-59616-0){:target="_blank"}.

## Introduction

In an age where technology reigns supreme, the debate surrounding the integration of artificial intelligence (AI) into various facets of our lives rages on. From streamlining processes to enhancing productivity, AI holds immense promise. But what about its impact on the very essence of our humanity? *Are we at risk of being sidelined by the very creations we’ve engineered?* Our recent research delved into this question, focusing on the delicate balance between automation and augmentation—in the realm of website usability evaluation.

We set out to explore the interplay between usability evaluators and AI tools, seeking to understand how varying levels of automation impact the ability of evaluators to identify usability issues. Our findings shed light on a nuanced landscape where *automation isn’t merely a threat to human involvement but can actually enhance it*.

## Introducing "SERENE"

We relied on the innovative [SERENE](https://github.com/uxsad) platform to explore the dynamic interplay between human evaluators and AI assistance in website usability evaluation. This tool represents a convergence of two pivotal trends in usability evaluation: the measurement of user emotions and the detection of actual usability problems.

Over recent years, there has been a surge in solutions aimed at automating aspects of usability evaluation. Some rely on affective computing techniques to recognize emotions without linking them to usability, while others provide static analyzers that may not accurately pinpoint usability problems.

Unlike its predecessors, SERENE bridges the gap by measuring the emotions experienced by website visitors during their interactions without requiring additional software or hardware on their devices. By privately recording mouse and keyboard activity, SERENE employs an AI model based on neural networks to predict user emotions moment by moment. This allows SERENE to predict the average emotions experienced during interaction with each user interface (UI) element.

To detect usability problems, drawing from studies linking perceived usability with emotional responses, SERENE operates on the premise that poorly designed UI elements evoke negative emotions in users. It suggests potential usability problems based on areas where negative emotions exceed a certain threshold.

## Our Research

In our study, we compared three different approaches: full automation, partial automation (a middle-ground condition), and augmentation.

<figure class="figure">
<img class="img-fluid figure-img" src="{% link assets/images/posts/scirep-serene/automation-modalities.png %}" title="Automation modalities" alt="Representation of the three visualization modalities" />
<figcaption class="figure-caption">The different levels of automation/augmentation implemented in SERENE to help discover usability problems: a) a list of the usability problems; b) a heatmap showing the concentration of the emotions overlapped to the webpage; c) the heatmap of the previous visualization also extended with purple rectangles highlighting potential usability problems.</figcaption>
</figure>

The different levels of automation/augmentation implemented in SERENE to help discover usability problems: a) a list of the usability problems; b) a heatmap showing the concentration of the emotions overlapped to the webpage; c) the heatmap of the previous visualization also extended with purple rectangles highlighting potential usability problems.

1. **Full Automation:** This visualization presents users with a textual list of UI elements potentially affected by automatically detected usability problems for each webpage. Additionally, the related website is displayed below the list.
2. **Full Augmentation:** In this visualization, a heatmap is overlaid on each webpage, accompanied by a menu allowing evaluators to switch between three key emotions: contempt, joy, and engagement. This approach empowers evaluators to interpret emotion concentration on UI elements freely.
3. **Middle-ground:** This visualization is a hybrid of the previous ones. As in full augmentation, a heatmap is overlaid on each webpage, allowing evaluators to freely interpret emotions on the UI. However, automatically-detected usability problems are highlighted by boxes, suggesting evaluators their presence.

To conduct our research, we designed an experimental evaluation using a survey and involving users, more precisely, usability evaluators. Participants were tasked with evaluating two distinct websites, with each participant being supported by one of three different SERENE solutions, each offering varying levels of automation. Our experimental design followed a *between-subject approach*, with the level of automation serving as the independent variable: each participant is only exposed to one condition.

The primary aim of our study was to address the research question: "How does the level of automation affect the identification of usability problems?" To answer this question, we defined eight metrics to quantify the users’ correct decisions, errors, and biases. More precisely, 4 metrics deal with how users perceive AI suggestions and decisions, while 4 metrics deal with their perceived severity.

## Results

The results were intriguing. A fully automated approach indeed proved adept at identifying significant usability problems, particularly those of medium to high severity. This underscores the efficiency and effectiveness of AI in specific contexts. What truly caught our attention was the potential of augmented approaches: by blending human expertise with AI assistance, we discovered a sweet spot where low-severity usability issues were more readily detected.

## Conclusions

*So, what does this mean for the future of website usability evaluation?*

It’s not a question of humans versus machines but rather a harmonious fusion of both. In other words, the Human-Centred AI framework allows to blend human decision-making and expertise and the capabilities of AI. Our study provides tangible proof of the need to strike a balance between humans and AI, harnessing the best of both worlds.

In essence, our research shows that we must embrace the symbiotic relationship between humanity and AI without forgetting the need for human-centered approaches that define the requirements and goals of the system—tipping the scale of automation and augmentation.

## My Perspective

<figure>
  <blockquote class="blockquote">
    <p>I loved conceiving, designing, conducting and analyzing this experiment! It was really interesting and it provided a ground to test the basic assumptions of Human-Centered Artificial Intelligence: wether or not AI should augment rather than automate humans. And that is what I believe is the main takeaway of the study. The empirical data clearly show that providing full control to users, or augmenting their capabilities, by default is not the right approach. In fact, a fully automated approach (i.e., replacing users - even if the negative connotation of the term should be dropped) may be beneficial in some cases, depending on users goals. This highlights the need for user study from the start when designing AI!</p>
  </blockquote>
  <figcaption class="blockquote-footer">
    <cite title="Andrea Esposito">Andrea Esposito</cite>
  </figcaption>
</figure>
