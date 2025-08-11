.\" Compile using *ROFF and both MM and PDFMARK macros
.\" No additional preprocessor is needed
.PF "''- % -''"
.PH "'Esposito A.''Beyond Automation, Toward Symbiosis'"
.nr N 2
.ds HF "3 3 2 2 2 2 2
.ds PDFHREF.COLOUR   0.35 0.00 0.60
.ds PDFHREF.BORDER   0 0 0
.nr PDFOUTLINE.FOLDLEVEL 3
.pdfview /PageMode /UseOutlines
.\" ***************************************************************
.\" PDF metadata
.pdfinfo /Title "Beyond Automation, Toward Symbiosis: Interactions Between Humans and Artificial Intelligence"
.pdfinfo /Author "Andrea Esposito"
.TL
Beyond Automation, Toward Symbiosis:
.br
Interactions Between Humans and Artificial Intelligence
.AF "University of Bari Aldo Moro, Department of Computer Science"
.ds BA "Bari, Italy
.AU "Andrea Esposito" AE "BA" "Department of Computer Science"
.AT "Ph.D. Student & Research Fellow"
.ND "Nov 26, 2024"
.AS 0
We are now living in an era where artificial intelligence (commonly known as AI)
is no longer a distant concept confined to research laboratories or science
fiction books. Instead, it has become a reality that intertwines with our daily
lives (albeit, at times, not without issues). We interact with AI systems
daily, often without even realizing it: from voice assistants that respond to
our requests to recommendations from our favorite streaming platforms about
which TV series to watch when we're bored on the couch. And here lies the first
warning sign: AI is no longer just an observer learning from our behaviors but
is starting to influence them.
.AE
.MT 4
.\".DS
.\".PDFPIC -C  "banner.pdf"
.\".DE
.2C
.BS
.1C
\l'12'
.br
.sp -0.25
.ps -2
Copyright \[co] 2024 held by the Author
.br
.sp -0.25
First published (in italian) in
.I "MagIA" :
the original article is available
.pdfhref W -D "https://magia.news/oltre-lautomazione-verso-una-simbiosi-le-interazioni-tra-esseri-umani-e-intelligenza-artificiale/" -A . -- "here"
.2C
.BE
.H 1 "Introduction: Human-AI Interaction"
.pdfhref O 1 "Introduction: Human-AI Interaction"
.pdfhref M "introduction-human-ai-interaction"
.P
We are now living in an era where artificial intelligence (commonly
known as AI) is no longer a distant concept confined to research
laboratories or science fiction books.
Instead, it has become a reality that intertwines with our daily lives
(albeit, at times, not without issues\*F.
We interact with AI systems daily, often without even realizing it: from
voice assistants that respond to our requests to recommendations from
our favorite streaming platforms about which TV series to watch when
we\(cqre bored on the couch.
And here lies the first warning sign: AI is no longer just an observer
learning from our behaviors but is starting to influence them.
.FS
For example, one can refer to the various cases of accidents caused by
autonomous vehicles:
.pdfhref W "https://www.theguardian.com/technology/2024/apr/26/tesla-autopilot-fatal-crash" 
.FE
.P
These interactions between humans and AI go beyond merely using
technology; they touch deeply on aspects of our identity, our
relationships, and the decisions we make every day.
These connections can provide help and support but also bring various
risks and challenges, such as the loss of skills, commonly referred to
in research as \(lqdeskilling\*(Rf.\(rq The growing presence of AI in
society raises complex questions: How do we want to relate to it?
What role do we want to assign it in our lives?
And how ready are we to trust decisions that, in some sense, are not
entirely our own?
.RS
Sambasivan, Nithya, and Rajesh Veeraraghavan.
\(lqThe Deskilling of Domain Expertise in AI Development.\(rq In
.I "CHI Conference on Human Factors in Computing Systems" ,
1\(en14.
New Orleans LA USA: ACM, 2022.
.pdfhref W -A "." -P "DOI: " -D "https://doi.org/10.1145/3491102.3517578" -- "10.1145/3491102.3517578"
.RF
.P
In this article, we will briefly explore these questions, aiming to
prompt readers to reflect on what it might mean to interact with AI.
.H 1 "Types of Interaction with Artificial Intelligence"
.pdfhref O 1 "Types of Interaction with Artificial Intelligence"
.pdfhref M "types-of-interaction-with-artificial-intelligence"
.P
AI has become an invisible companion in our daily activities, enabling
various services we use every day in a wide range of ways and sectors,
from entertainment to healthcare, through different modes of
interaction.
.P
Undoubtedly, the most successful mode of interaction with AI in this
particular period is that of chatbots and voice assistants, more
generally referred to as \(lqconversational agents,\(rq such as the
modern
.pdfhref W -D "https://chatgpt.com/" -- "ChatGPT"
or the more familiar
.pdfhref W -D "https://www.apple.com/it/siri/" -- "Siri"
and
.pdfhref W -D "https://developer.amazon.com/it-IT/alexa" -A "." -- "Alexa"
This type of interaction is also used by various \(lqassistants\(rq
found on the websites of telecom providers and other companies, offering
initial support to their customers.
.P
To better understand the different modes of interaction between humans
and AI, it is useful to consider some theoretical models that analyze
levels of automation.
These models provide an interesting perspective on how technology can
automate various tasks while varying the degree of human involvement and
control.
.DF
.PDFPIC -C  "one-dim.pdf"
.FG "One-dimensional model of automation"
.DE
.P
One of the earliest models of automation, and also one of the most
frequently cited, defines a one-dimensional scale of task automation
levels\*(Rf.
This model, based on 10 levels, has two extremes: total human control (a
level where the machine provides no support or automation for the
specific task) and total automation (a level where the human has no role
in performing the task, not even as a supervisor).
.RS
Parasuraman, R., T.B.
Sheridan, and C.D.
Wickens.
\(lqA Model for Types and Levels of Human Interaction with
Automation.\(rq \f[I]IEEE Transactions on Systems, Man, and Cybernetics
\(em Part A: Systems and Humans\f[R] 30, no.
3 (2000): 286\(en97.
.pdfhref W -A "." -S "DOI: " -D "https://doi.org/10.1109/3468.844354" -- "10.1109/3468.844354"
.RF
.DF
.PDFPIC -C "2dim.pdf"
.FG "New two-dimensional model of automation"
.DE
.P
A more recent model, on the other hand, separates the degree of
automation from the level of human control, offering a two-dimensional
view of the relationship between humans and AI (or, more generally,
machines)\*(Rf.
This approach allows for the identification of four types of systems:
.RS
Shneiderman, Ben.
\(lqHuman-Centered Artificial Intelligence: Reliable, Safe &
Trustworthy.\(rq \f[I]International Journal of Human\(enComputer
Interaction\f[R], March 23, 2020.
.pdfhref W -A "." -P "DOI: " -D "https://doi.org/10.1080/10447318.2020.1741118" -- "10.1080/10447318.2020.1741118"
.RF
.AL
.LI
Non-automated, with high human control: systems based on the user\(cqs
skill (e.g., a piano).
.LI
Fully automated, with minimal human control: entirely managed by the
machine (e.g., car airbags).
.LI
Low automation, with low human control: for example, a watch.
.LI
Highly automated, with high human control: for example, an automatic
camera that allows the user to adjust its settings.
.LE
.P
This last category represents the ideal for AI systems, as it ensures
reliability, safety, and trust.
.P
It is interesting to note, however, that systems can sometimes be overly
controlled by the user or \f[I]excessively\f[R] automated.
These are cases where AI-based systems lead users to rely too heavily on
them, potentially resulting in accidents, even fatal ones\*F.
.FS
See the various cases of accidents caused by autonomous vehicles
mentioned earlier:
.pdfhref W "https://www.theguardian.com/technology/2024/apr/26/tesla-autopilot-fatal-crash"
.FE
.H 1 "The Approach Recommended by Research"
.pdfhref O 1 "The Approach Recommended by Research"
.pdfhref M "the-approach-recommended-by-research"
.P
In this context, several researchers have sought to validate the
theories presented in the two-dimensional model of human-AI interaction.
A particularly intriguing question arises: \f[I]is automation truly the
best way to leverage AI?\f[R]
.P
To explore this, Italian researchers (including the author of this note)
investigated various ways to design artificial intelligence in the
specific application context of evaluating the usability (a quality
dimension) of web pages\*(Rf.
The results are particularly thought-provoking: the analysis showed that
a fully automated approach was highly effective at identifying webpage
issues, especially the most severe ones.
This highlights the remarkable efficiency and accuracy of AI when
applied to specific tasks.
.RS
Esposito, Andrea, Giuseppe Desolda, and Rosa Lanzilotti.
\(lqThe Fine Line between Automation and Augmentation in Website
Usability Evaluation.\(rq \f[I]Scientific Reports\f[R] 14, no.
1 (May 2, 2024): 10129.
.pdfhref W -A "." -P "DOI: " -D "https://doi.org/10.1038/s41598-024-59616-0" -- "10.1038/s41598-024-59616-0"
.RF
.P
However, the most intriguing insight emerged when exploring alternative
approaches aimed at \f[I]enhancing\f[R] human capabilities rather than
replacing them through task automation.
By combining the refined judgment of human experts with the analytical
capabilities of AI, researchers discovered a \(lqsynergy\(rq that
significantly improves the detection of lower-severity issues.
This hybrid approach leverages the strengths of both humans and
machines, enabling the identification of subtle problems that would
otherwise elude an analysis performed solely by automation or humans
alone.
.P
This finding suggests that, while automation excels at identifying more
obvious problems, integrating human expertise with AI can create a more
comprehensive evaluation process.
Thus, the choice of the right way to interact with AI is closely tied to
the specific \f[I]needs\f[R] and \f[I]tasks\f[R] of end users \(em that
is, us!
.H 1 "A Possible Future: A Symbiosis Between Humans and AI"
.pdfhref O 1 "A Possible Future: A Symbiosis Between Humans and AI"
.pdfhref M "a-possible-future-a-symbiosis-between-humans-and-ai"
.P
AI is becoming increasingly present in our lives, promising numerous
improvements but also exposing us to various risks.
Throughout this article, we explored different levels of interaction
between humans and AI, highlighting how the integration of human
expertise and AI capabilities enables more comprehensive and precise
outcomes, even capturing subtle details.
The discovery of the potential of this \(lq\f[I]symbiosis\f[R]\(rq
between humans and AI points to a promising model for the future: not
automation that replaces humans, but AI that \f[I]collaborates\f[R] with
us, \f[I]amplifying\f[R] our potential.
.DF L F
.PDFPIC "future.pdf"
.FG "Image generated using AI (GPT-4o)"
.DE
.P
This \(lqsymbiotic\(rq relationship between humans and AI goes beyond
mere efficiency.
It represents a model that combines human sensitivity and awareness with
the analytical power of machines.
AI can precisely solve significant and repetitive problems, but it is
often humans, with their intuition and judgment, who can perceive
nuances and complexities that an automated system cannot grasp on its
own.
This balance between autonomy and assistance gives us the opportunity to
design a future in which AI and humanity collaborate to achieve results
that neither could accomplish alone.
In conclusion, the true value of AI will emerge not just from its
technical capabilities, but from the quality of the relationship we
build with it.
.NCOL
.RP 1 3
.RL
.pdfsync
.\" vim: ft=troff
