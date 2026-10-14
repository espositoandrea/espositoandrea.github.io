---
layout:	post
title:	"My Thoughts on the Evolution of AI Research"
date:	2023-10-18
image: /assets/images/posts/medium/1On6l0D0R-Zoo2cctcSO2Vw.png
canonical_url: https://medium.com/@espositoandrea/my-thoughts-on-the-evolution-of-ai-research-445660180906
canonical_site_name: Medium
---

### Introduction

Artificial Intelligence (AI) has been making significant strides in recent years, thanks to the advent of Deep Learning algorithms and the rise of large-scale datasets. This progress has led to the development of very powerful models, like the Large Language Models GPT-3 by [OpenAI](https://openai.com){:target="_blank" rel="noopener noreferrer"}, which has taken the AI world by storm. These models have significantly advanced Natural Language Processing and have become a driving force for innovation in the field. The powerful impact of such models is, to use a euphemism, *extremely exciting* for a young researcher like me.

However, after a very interesting lecture by Prof. Xiaowei Xu at the [9th International School of Deep Learning](http://deeplearn.irdta.eu/2023sp/){:target="_blank" rel="noopener noreferrer"}, I have to admit I am becoming increasingly worried about the impact that these models have. With the rise of large-scale models and the discovery of their scaling capabilities, I fear that AI is becoming increasingly monopolized by the few who have the resources to build such models. In my view, this raises the question of whether it is time to introduce new parameters in AI research when selecting papers for publication.

### Toward Green AI

In a recent [Twitter thread](https://twitter.com/espositoandrea_/status/1644024136774164481?s=61&t=ST82pblAQ36ndIq3wvjTdg){:target="_blank" rel="noopener noreferrer"}, I expressed my concern that only using accuracy as a measure of performance reduces competition to the few who have the resources to train huge models. This, in turn, *stifles innovation* and locks out poor researchers who work in universities with limited funds. I suggested that we need to introduce formal metrics, such as “*accuracy per FLOP*[^1],” which averages performances over the model size. The idea behind this metric is that it would measure the accuracy of a model relative to the number of floating-point operations (FLOPs) it requires. This metric would be especially useful for smaller models that might not have the accuracy of larger models but are more efficient in terms of computational resources. This would allow a fair comparison for smaller, weaker models too.

I then discovered that the idea of using metrics such as “accuracy per FLOP” is not new: in the December 2020 issue of Communications of the ACM, Schwartz et al. coined the term “[Green AI](https://doi.org/10.1145/3381831){:target="_blank" rel="noopener noreferrer"}”, which refers to research in AI that takes into account the computation cost[^2]. However, to the extent of my knowledge, it has not gained enough traction in the AI community, especially in the business setting. Fortunately, the research interest in this seems to be increasing[^3].

Furthermore, I expressed concern that current research simply translates to *trying a bigger model* without challenging the base ideas of the model. There is a need for AI researchers to explore new techniques and models that can yield better accuracy per FLOP (even at the cost of — temporarily — reducing accuracy). This approach would ensure that researchers are not just trying to build bigger models but are also exploring new ways to improve the efficiency of the models.

### Conclusions

In conclusion, the development of large language models has brought many exciting possibilities, but it is essential to ensure that the research is not monopolized by the few who have the resources to build such models. The introduction of new parameters such as “accuracy per FLOP” could level the playing field and allow smaller models to compete on an equal footing. Additionally, researchers must explore new techniques and models to improve efficiency of the models rather than merely building larger models. Only then can we ensure that AI research is inclusive, innovative, and making progress toward creating AI that benefits everyone. Similarly, we should remember that *AI is built to be used by humans*, thus the interaction with humans should be among the main focuses of AI researchers (this is what *Human-Centered AI* is about). In my opinion, failure to shift the focus of current research will quickly bring a *new Artificial Intelligence Winter*.

### References

[^1]: Esposito, Andrea. “‘Accuracy per FLOP’: A Green AI Metric for Fair and Efficient AI Development.” *The Journal of Brief Ideas (*July 5, 2024). DOI:[10.5281/zenodo.12660216](https://doi.org/10.5281/zenodo.12660216).
[^2]: Roberto Verdecchia, June Sallou, and Luís Cruz. 2023. A systematic review of Green AI. *WIREs Data Mining and Knowledge Discovery* 13, 4 (2023), e1507. DOI:[10.1002/widm.1507](https://doi.org/10.1002/widm.1507)
[^3]: Roy Schwartz, Jesse Dodge, Noah A. Smith, and Oren Etzioni. 2020. Green AI. *Commun. ACM* 63, 12 (November 2020), 54–63. DOI:[10.1145/3381831](https://doi.org/10.1145/3381831)

*This idea has been published in “The Journal of Brief Ideas” on July 5, 2024. This blog post has been updated to add a link back to the idea. If you want to cite this, please use the following DOI: [10.5281/zenodo.12660216](https://doi.org/10.5281/zenodo.12660216){:target="_blank" rel="noopener noreferrer"}. You can find the original publication mirrored in [this blog post]({% post_url 2024-05-31-accuracy-per-flop %}).*
