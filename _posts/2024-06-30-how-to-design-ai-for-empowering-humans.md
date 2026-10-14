---
layout:	post
title:	"How to design AI for empowering humans"
date:	2024-06-30
image_alt: Cover image of the post. A robotic hand and a human hand with their protruded index fingers almost touching each other. Behind the two hands, near the tips of the index fingers, the text “AI” on a blue background.
image: /assets/images/posts/medium/1WeqMmn78Dd9e8SZSE-Va1g.jpeg
image_caption: Photo by [Igor Omilaev](https://unsplash.com/@omilaev){:target="_blank" rel="noopener noreferrer"} from [Unsplash](https://unsplash.com/photos/two-hands-touching-each-other-in-front-of-a-pink-background-gVQLAbGVB6Q){:target="_blank" rel="noopener noreferrer"}

canonical_url: https://medium.com/design-bootcamp/how-to-design-ai-for-empowering-humans-9d7cf49fe6c4
canonical_site_name: Bootcamp (Medium)

paper: Esposito2024Fine
excerpt: Balancing automation and human expertise when designing AI requires understanding your users’ needs.
---

Nowadays, Artificial Intelligence has permeated into almost every aspects of society. Even governmental and religious leaders are now discussing the impact that this technology have and will continue to have on our life. From tailored recommendations on streaming or shopping platforms, to virtual assistants, AI’s presence is ubiquitous. Although AI proves to be extremely useful, **fear and distrust** still linger: discussion on ethics, creativity, and many other aspects is still lively both in academia and in the greater society. Perhaps the more prevalent worry is that **AI may, one day, replace us** — both in our jobs and in our creative outlets. This fear stems from the approach and goals used until today while designing AI: the one of automation.

However, the true potential of AI lies not just in *automating* tasks, but in *augmenting* human capabilities, thus empowering us to achieve more. Designing AI with this new focus means creating systems that **enhance our abilities** rather than replacing them.

This approach is strongly advocated by Prof. Ben Shneiderman, who published a seminal book on the topic[^1]. Human-Centred AI — the name of this new approach — involves thoughtful consideration of how AI can **complement human skills**, support us, and enhance productivity, without hindering our autonomy and creativity. This is not dissimilar to what Human-Computer Interaction and (more precisely) Interaction/UX Design do with “classical” software.

In this blog post, we will explore some insights from my recent **research paper**, published in [Nature Scientific Reports](https://www.nature.com/srep/){:target="_blank" rel="noopener noreferrer"}: “The Fine Line Between Automation and Augmentation in Website Usability Evaluation.”[^2] More precisely, we will analyze the delicate balance between using AI to automate processes and using it to augment human capabilities, highlighting how knowing the users goals is crucial for AI — exactly how Interaction/UX design proved it to be crucial for classical software. The research paper is open access (thus, completely free) and can be found at the following link.

*Let’s dive into it, but first here’s a quick visual abstract of our paper as a TL;DR!*

<figure>
<img src="/assets/images/posts/medium/1Q1ek1v0x0o1bv2ZKg2Gs8A.png" alt="A visual abstract for the manuscript titled “The fine line between automation and augmentation in website usability evaluation.” It feature the title of the paper on top, while the journal logo, authors, and DOI are at the bottom. The main section is subdivided in three columns, titled (from left to right) “Context”, “Method”, and “Results”. The content of each column is described in the main text of the article.">
<figcaption>Visual abstract of the paper. Image by the author.</figcaption>
</figure>

## The Role of AI in Modern Technology

The journey of AI started in a [1956 workshop in Dartmouth](https://home.dartmouth.edu/about/artificial-intelligence-ai-coined-dartmouth){:target="_blank" rel="noopener noreferrer"}, of which John McCarty was one of the main promoters. Since then, AI has always been an interesting field for research. Initial applications were mostly on problem solving or games (e.g., chess). However, in the following decades, also thanks to the massive increase in available and affordable computational power, AI saw an increase in power and capabilities. Nowadays, [AI is everywhere](https://www.politico.com/news/2024/02/04/how-ai-is-quietly-changing-everyday-life-00138341){:target="_blank" rel="noopener noreferrer"}and has become an end-user product: starting from intelligent assistants on our smartphones, recommender systems for shopping or streaming, and other applications, it is impossible to think to go by a single day without interacting at least one form of AI — unless you choose to go completely “off the grid.”

Despite its ubiquitous presence, it’s crucial to distinguish between two key paradigms in AI: *automation and augmentation*. **Automation** involves using AI to perform tasks **without** human intervention. This can lead to increased efficiency and cost savings but rises concerns about the risk job displacement and a reliance on technology at the expense of human skills.

**Augmentation**, on the other hand, emphasizes using AI to **enhance** human capabilities. Thus, rather than replacing humans, augmented AI acts as a “collaborative partner,” providing insights, suggestions, and support to help people make better decisions and perform tasks more effectively. This approach maintains the central role of human judgment and creativity while leveraging the computational power and data analysis capabilities of AI.

By focusing on augmentation, we can design AI systems that empower users, making them more productive and enabling them to achieve things previously thought impossible. This balance between automation and augmentation is a critical theme in designing AI that truly benefits society, and it is the foundation of the insights presented in my research on website usability evaluation.

## A Brief Summary of the Research

In my latest research effort, as part of the [IVU Laboratory in Bari](https://ivu.di.uniba.it){:target="_blank" rel="noopener noreferrer"}, we set out to explore the way automation and approaches change the way AI systems are perceived. This was done by involving the same subjects that would be greatly impacted by an AI system: its end users. More precisely, we focused on the context of [usability evaluation](https://www.nngroup.com/articles/usability-testing-101/){:target="_blank" rel="noopener noreferrer"}.

In previous work[^3], we had implemented an AI system that is able to detect emotions by analyzing the way users interact with a web page (i.e., by analyzing their mouse movements and keyboard use — while also ensuring privacy). Based on such model, we constructed a survey where emotion values were shown to usability evaluators.

Furthermore, we identified usability and UX issues connected to the emotion values. These issues are also shown to the evaluators, alongside the emotion values, as if it was part of the output of the AI model (similar to what happens in a Wizard of Oz study).

In showing the emotion values and the connected issues, we varied the “automation level,” meaning that we simulated the adoption of either an automation or an augmentation approach. The way the output was presented to evaluators is shown in the next image.

![The different levels of automation/augmentation implemented in SERENE to help discover usability problems: a) a list of the usability problems; b) a heatmap showing the concentration of the emotions overlapped to the webpage; c) the heatmap of the previous visualization also extended with purple rectangles highlighting potential usability problems. Image by the author and extracted from the paper.](/assets/images/posts/medium/185LxGVVHkkQQVuzHXnLQlA.png){:standalone}

The data collection phase involved a total of 99 usability evaluators, and each of them interacted with only one of the automation levels. The results were then analyzed statistically through the use of custom metrics defined to evaluate the amount of usability issues found and the errors made by the evaluators.

## Automation vs. Augmentation: A Delicate Balance

The findings of our research were both revealing and thought-provoking. In fact, our analysis showed that a **fully automated** approach was **highly effective** at pinpointing **major usability issues**, especially those categorized as medium to high severity. This highlights the remarkable efficiency and precision of AI when applied to specific tasks within usability evaluation.

However, the most fascinating insight emerged from exploring **augmented** approaches. By combining the nuanced judgment of human experts with the analytical capabilities of AI, we uncovered a **synergy** that significantly enhanced the detection of **low-severity usability issues**. This hybrid approach capitalized on the strengths of both human and machine, allowing the identification of subtle problems that might otherwise be overlooked by either automation or humans alone.

This discovery suggests that while automation excels in efficiently handling more straightforward, higher-impact usability problems, the integration of human expertise with AI can create a more comprehensive evaluation process. Ultimately, the choice of the right automation level highly **depends** on the specific **needs and tasks** of your end-users. For example, if efficiency is key, an automated approach may be preferred. On the contrary, if the goal is discovering smaller issues and perfecting the details, an augmented approach must be preferred.

## Conclusion and Practical Tips

In conclusion, our research shows that efforts should not be put in choosing between humans and machines, but rather on creating a seamless integration of both — almost through a **symbiotic relationship**. The Human-Centered AI framework demonstrates how combining human decision-making and expertise with AI capabilities can yield superior results.

Ultimately, our research highlights the need to embrace the symbiotic relationship between humans and AI, while maintaining a focus on **human-centered design** principles. This approach ensures that the requirements and goals of the system are aligned with **human needs**, striking the right **balance** between automation and augmentation. By doing so, we can achieve more comprehensive and effective usability evaluations, benefiting from the best of both worlds.

To conclude this story, I want to share a **practical tip**, stemmed from what I learned from this research. Before embarking on an AI creation journey, take the time to thoroughly understand what your users actually need. Conduct user research to gather insights into their requirements and preferences. This will help you determine the appropriate level of automation and ensure that the AI system you develop truly enhances their experience. By aligning the AI’s capabilities with user needs, you can create more effective and user-friendly solutions.

[^1]: Ben Shneiderman. Human-centered AI, Oxford University Press, 2022.
[^2]: Andrea Esposito, Giuseppe Desolda, and Rosa Lanzilotti. 2024. The Fine Line between Automation and Augmentation in Website Usability Evaluation. *Scientific Reports* 14, 1 (May 2024), 10129. DOI:[10.1038/s41598–024–59616–0](https://doi.org/10.1038/s41598-024-59616-0){:target="_blank" rel="noopener noreferrer"}
[^3]: Giuseppe Desolda, Andrea Esposito, Rosa Lanzilotti, and Maria F. Costabile. 2021. Detecting Emotions Through Machine Learning for Automatic UX Evaluation. In *Human-Computer Interaction — INTERACT 2021*, Carmelo Ardito, Rosa Lanzilotti, Alessio Malizia, Helen Petrie, Antonio Piccinno, Giuseppe Desolda and Kori Inkpen (eds.). Springer International Publishing, Cham, 270–279. DOI:[10.1007/978–3–030–85613–7\_19](https://doi.org/10.1007/978-3-030-85613-7_19){:target="_blank" rel="noopener noreferrer"}
  