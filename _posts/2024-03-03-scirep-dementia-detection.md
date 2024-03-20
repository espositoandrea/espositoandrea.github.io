---
layout: post
title: "The Future of Alzheimer's Diagnosis: Unlocking Insights with Multi-modal Imaging Models"
image: /assets/images/posts/scirep-dementia-detection/banner.jpg
lang: en
category: Paper Summaries
tags: [ai, cnn, diagnosis, dementia, alzheimer, xai]
excerpt: >-
    Dementia affects ~55 million individuals worldwide, with Alzheimer’s disease
    (AD) being the predominant type. Artificial Intelligence (AI) may aid in its
    diagnosis. We propose and evaluate multi-modal models for the task,
    incorporating eXplainable Artificial Intelligence for diagnostic
    transparency.
canonical_url: 'https://communities.springernature.com/posts/the-future-of-alzheimer-s-diagnosis-unlocking-insights-with-multi-modal-imaging-models'
paper: Castellano2024Automated
---

Read the full paper on [Springer Link](https://link.springer.com/article/10.1038/s41598-024-56001-9){:target="_blank"}.  This post first appeared in [Springer Nature Research Communities](https://communities.springernature.com/posts/the-future-of-alzheimer-s-diagnosis-unlocking-insights-with-multi-modal-imaging-models){:target="_blank"}.

## Introduction

Dementia affects approximately 55 million individuals worldwide, with
Alzheimer's disease (AD) being the predominant type, accounting for
60-70% of all cases. Despite its staggering prevalence, a cure remains
elusive, highlighting the crucial need for early diagnosis,  as it
enables timely and optimal management strategies that significantly
benefit patients, families, and caregivers alike.

Artificial Intelligence (AI), particularly Deep Learning, shows promise
in transforming AD diagnosis. Neuroimaging techniques like Magnetic
Resonance Imaging (MRI) and amyloid Positron Emission Tomography (PET)
scans offer valuable biomarkers. Previous research has primarily focused
on uni-modal approaches, utilizing mainly a single imaging technique for
the diagnosis. Multi-modal neuroimaging, instead, still needs to be
deeply explored, with few studies aiming to maximize performance by
leveraging the combined strengths of different imaging modalities.

<figure class="figure">
<img class="img-fluid figure-img" src="/assets/images/posts/scirep-dementia-detection/samples.png" title="Example of MRI and PET scans" alt="Examples of MRI and PET scans" />
<figcaption class="figure-caption">Examples of an MRI (on the left) and a PET scan (on the right).</figcaption>
</figure>

We addressed the gap by proposing and evaluating Convolutional Neural
Network (CNN) models using 2D and 3D MRI and PET scans in both uni-modal
and multi-modal configurations. Additionally, the incorporation of
eXplainable Artificial Intelligence (XAI) enhances transparency in
decision-making for AD diagnosis.

## Our Research

Our models leverage CNNs as the foundational architecture, tailored to
accommodate the specific characteristics of the input scans---either in
terms of their dimensionality or modality. CNNS are a particular type of
artificial neural networks that can learn to recognize patterns and
features in pictures, by breaking them down to smaller pieces. This
enables CNNs to identify objects or patterns in a way similar to how our
brain processes visual information.The rationale behind selecting CNNs
is rooted in their proven capability and efficiency in handling image
data, particularly in medical imaging and diagnostics, as they excel in
automatically detecting critical features.

Our study systematically explored several variations of the proposed CNN
architecture, tailored to different imaging modalities and
dimensionalities. We experimented with several 2D and 3D approaches
using MRIs and PET scans.

The results are promising: all models reached a 70--95% diagnostic
accuracy. Notably, models leveraging three-dimensional inputs
outperformed their two-dimensional counterparts. Furthermore, our
analysis revealed that MRI scans in 2D or 3D formats consistently
provided superior results to amyloid PET scans, with an accuracy
difference of approximately 8--10%. Utilizing a combination of both 3D
MRIs and 3D amyloid PET scans in a "fusion" model allowed us to reach a
staggering accuracy of 95%. This suggests that MRI and PET scans fulfill
complementary roles in disease prediction, while MRI proves crucial in
uni-modal scenarios. Furthermore, the fusion model's remarkable
sensitivity (the ability to avoid false negatives)  is particularly
advantageous for disease detection.

<figure class="figure">
<img class="figure-img img-fluid" src="/assets/images/posts/scirep-dementia-detection/merged-model.jpg" title="Architecture of the &quot;fusion&quot; model" alt="Architecture of the &quot;fusion&quot; model presented in the manuscript" />
<figcaption class="figure-caption">Architecture of the “fusion” model.</figcaption>
</figure>

## The Need for Explainability

As Machine Learning and AI play increasingly vital roles across diverse
applications, there is a growing interest in XAI to shed light on the
hidden AI decision-making process. The need for transparency is
particularly crucial in medicine, where opaque algorithms' ethical and
safety implications cannot be overlooked.

Our models are inherently "black-box" in nature, as they do not offer
interpretable or explainable outcomes without further analysis. To
bridge this gap, we applied a state-of-the-art technique,
Gradient-weighted Class Activation Mapping (Grad-CAM), to generate maps
that emphasize the regions within the original image most influential in
predicting the disease or its absence.

### Understanding the Model's Insights

Overlaying Grad-CAM heatmaps onto the AAL2 atlas, a detailed anatomical
guide encompassing 120 brain regions, allowed us to precisely identify
the key areas influencing the model's classifications. Identifying
regions with mean Grad-CAM values in the top 90th percentile revealed
their critical role in the model's decision-making process, emphasizing
their potential relevance to Alzheimer's disease pathology.

<figure class="figure">
<img class="figure-img img-fluid"
src="/assets/images/posts/scirep-dementia-detection/both.png"
title="Heatmaps generated by Grad-CAM"
alt="Heatmaps for both MRIs and PET scans" />
<figcaption class="figure-caption">Three-dimensional
visualizations created from multiple axial brain slices, showcasing
Grad-CAM heatmaps for the positive class.</figcaption>
</figure>

For MRI scans, a notable consistency exists in the regions highlighted
across both groups, with the Temporal Lobe emerging as the most critical
area for classification. This observation aligns with established
research indicating Temporal Lobe atrophy as a crucial predictor of AD
and other dementia forms, particularly emphasizing the significance of
the Medial Temporal Lobe. Interestingly, the Middle Cingulate Gyrus and
the Left Inferior Parietal Gyrus were identified as unique indicators
for the negative and positive groups. Additionally, the Precentral Gyrus
and Precuneus, both associated with AD pathology, were identified as
relevant, supporting their roles as early biomarkers of AD.

PET scans revealed a substantial overlap in significant regions between
the positive and negative groups, similar to MRI findings. Apart from
the Middle Temporal Gyrus, Precentral Gyrus, and Precuneus, the Frontal
Gyrus (encompassing the superior, middle, and inferior triangular parts)
was markedly significant in AD detection. The overlap of significant
regions across both groups, for MRI and PET, suggests that our model
consistently focuses on the same areas for discrimination.

## Conclusion

In our research, we worked on creating a multi-modal diagnostic model
for Alzheimer's Disease using both 3D MRI and amyloid PET imaging. We
discovered that these modalities give us different but helpful views,
making our AD prediction models better. Our experimental results show
that our new methods not only match but might even beat the best methods
we have now. Furthermore, by gaining insights into the regions of the
images the AI models were focusing on, we highlighted critical areas in
the brain related to AD, agreeing with what other researchers are
finding nowadays. For additional details on the methods and results of
our study, we invite readers to explore the open-access paper linked at
the start of this post.