---
layout: post
title: My Thoughts on the Evolution of AI Research
image: /assets/images/banners/ai-post-og.png
lang: en
categories: [Thoughts]
tags: [ai, hcai]
excerpt: >-
    Artificial Intelligence (AI) has been making significant strides in recent years, thanks to the advent of Deep Learning algorithms and the rise of large-scale datasets. The powerful impact of such models is, to use a euphemism, extremely exciting for a young researcher like me. However, I have to admit I am becoming increasingly worried about the impact that these models have.
---

## Introduction

Artificial Intelligence (AI) has been making significant strides in recent years, thanks to the advent of Deep Learning algorithms and the rise of large-scale datasets. This progress has led to the development of very powerful models, like the Large Language Models GPT-3 by [OpenAI](https://openai.com/), which has taken the AI world by storm. These models have significantly advanced Natural Language Processing and have become a driving force for innovation in the field. The powerful impact of such models is, to use a euphemism, _extremely exciting_ for a young researcher like me.

However, after a very interesting lecture by Prof. Xiaowei Xu at the [9th International School of Deep Learning](http://deeplearn.irdta.eu/2023sp/), I have to admit I am becoming increasingly worried about the impact that these models have. With the rise of large-scale models and the discovery of their scaling capabilities, I fear that AI is becoming increasingly monopolized by the few who have the resources to build such models. In my view, this raises the question of whether it is time to introduce new parameters in AI research when selecting papers for publication.

## Toward Green AI

In a recent [Twitter thread](https://twitter.com/espositoandrea_/status/1644024136774164481?s=61&t=ST82pblAQ36ndIq3wvjTdg), I expressed my concern that only using accuracy as a measure of performance reduces competition to the few who have the resources to train huge models. This, in turn, _stifles innovation_ and locks out poor researchers who work in universities with limited funds. I suggested that we need to introduce formal metrics, such as "_accuracy per FLOP_," which averages performances over the model size. The idea behind this metric is that it would measure the accuracy of a model relative to the number of floating-point operations (FLOPs) it requires. This metric would be especially useful for smaller models that might not have the accuracy of larger models but are more efficient in terms of computational resources.  This would allow a fair comparison for smaller, weaker models too.

I then discovered that the idea of using metrics such as "accuracy per FLOP" is not new: in the December 2020 issue of Communications of the ACM, Schwartz et al. coined the term "[Green AI](https://doi.org/10.1145/3381831)", which refers to research in AI that takes into account the computation cost [[2]](#Schwartz2020Green). However, to the extent of my knowledge, it has not gained enough traction in the AI community, especially in the business setting. Fortunately, the research interest in this seems to be increasing [[1]](#Verdecchia2023Systematic).

Furthermore, I expressed concern that current research simply translates to _trying a bigger model_ without challenging the base ideas of the model. There is a need for AI researchers to explore new techniques and models that can yield better accuracy per FLOP (even at the cost of - temporarily - reducing accuracy). This approach would ensure that researchers are not just trying to build bigger models but are also exploring new ways to improve the efficiency of the models.

## Conclusions

In conclusion, the development of large language models has brought many exciting possibilities, but it is essential to ensure that the research is not monopolized by the few who have the resources to build such models. The introduction of new parameters such as "accuracy per FLOP" could level the playing field and allow smaller models to compete on an equal footing. Additionally, researchers must explore new techniques and models to improve efficiency of the models rather than merely building larger models. Only then can we ensure that AI research is inclusive, innovative, and making progress toward creating AI that benefits everyone. Similarly, we should remember that _AI is built to be used by humans_, thus the interaction with humans should be among the main focuses of AI researchers (this is what _Human-Centered AI_ is about). In my opinion, failure to shift the focus of current research will quickly bring a _new Artificial Intelligence Winter_.

## References

1. {: #Verdecchia2023Systematic } Roberto Verdecchia, June Sallou, and Luís Cruz. 2023. A systematic review of Green AI. _WIREs Data Mining and Knowledge Discovery_ 13, 4 (2023), e1507. DOI:[10.1002/widm.1507](https://doi.org/10.1002/widm.1507){: target="_blank"}
2. {: #Schwartz2020Green } Roy Schwartz, Jesse Dodge, Noah A. Smith, and Oren Etzioni. 2020.  Green AI. _Commun. ACM_ 63, 12 (November 2020), 54–63. DOI:[10.1145/3381831](https://doi.org/10.1145/3381831){: target="_blank"}

*[AI]: Artificial Intelligence
*[FLOP]: Floating Point Operation
*[FLOPs]: Floating Point Operations
*[GPT-3]: Generative Pre-trained Transformer 3
