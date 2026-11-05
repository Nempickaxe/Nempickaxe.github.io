// Nemish Kanwar — CV (Typst source). Compile: typst compile cv.typ cv.pdf
// Single-column, text-based PDF: ATS parsers read it in natural order.

#let accent = rgb("#1d4ed8")
#let ink = rgb("#0f172a")
#let muted = rgb("#475569")

#set document(
  title: "Nemish Kanwar — Senior Data Scientist & Data Platform Architect",
  author: "Nemish Kanwar",
  keywords: ("Data Architect", "Data Science", "ML Engineering", "Lakehouse", "Cloud Modernization", "Spark", "GCP", "Terraform", "MLOps", "Generative AI"),
)
#set page(paper: "a4", margin: (x: 1.6cm, y: 1.4cm))
#set text(font: ("Inter", "Helvetica Neue", "Arial", "Liberation Sans"), size: 9.4pt, fill: ink, lang: "en")
#set par(justify: false, leading: 0.55em, spacing: 0.7em)
#set list(indent: 0.2em, body-indent: 0.5em, spacing: 0.45em, marker: [•])

#show heading.where(level: 1): it => {
  v(0.5em)
  text(size: 10pt, weight: "bold", fill: accent, tracking: 0.08em, upper(it.body))
  v(-0.55em)
  line(length: 100%, stroke: 0.6pt + accent)
  v(0.1em)
}

#let role(title, company, dates, place: none) = block(breakable: false, above: 0.9em, below: 0.4em)[
  #grid(
    columns: (1fr, auto),
    [*#title* · #company],
    text(fill: muted)[#dates#if place != none [ · #place]],
  )
]
#let sub(t) = block(above: 0.7em, below: 0.3em, text(weight: "semibold", fill: accent)[#t])
#let skill(label, items) = grid(
  columns: (3.6cm, 1fr), column-gutter: 0.3cm, row-gutter: 0.4em,
  text(weight: "bold")[#label], [#items],
)

// ── Header ─────────────────────────────────────────────
#align(left)[
  #text(size: 24pt, weight: "bold")[Nemish Kanwar] \
  #text(size: 11.5pt, fill: accent, weight: "semibold")[Senior Data Scientist & Data Platform Architect] \
  #v(0.2em)
  #text(fill: muted)[Bengaluru, India · #link("mailto:nemishkanwar@gmail.com")[nemishkanwar\@gmail.com] · 10 years in data, Spark & cloud]
]

= Summary
Data platform architect and Senior Data Scientist with 10 years of experience (7+ in data platforms and big-data engineering) designing and delivering Spark-based batch pipelines, cloud modernizations and MLOps foundations on GCP and AWS. At Target, I architect and own the migration of pricing batch workloads from legacy Oozie/Shepherd to Vertex AI and Dataproc, validate it against the production system before cutover, and standardize delivery through Terraform, CI/CD and reusable templates. I write the architecture decision records, run technical workshops for engineers and VP-level audiences, and mentor teammates. Seeking a Lead / Senior Data Architect role on Lakehouse and cloud data modernization.

= Core Skills
#skill("Architecture")[Modernization roadmaps, ADRs and trade-off analysis (cost, latency, risk), migration and cutover validation, data-quality gates, security and access design (IAM, secrets), runbooks, architecture workshops]
#skill("Data Platforms")[Apache Spark / PySpark (partitioning, caching, broadcast joins, executor sizing), Dataproc, BigQuery, Airflow, Airbyte, Kafka (MirrorMaker 2), Postgres, Databricks (model deployment)]
#skill("Cloud & DevOps")[GCP (Vertex AI, Dataproc, Cloud Run, GAR), AWS (SageMaker, EMR, Lambda, CloudWatch), Terraform, Atlantis, Docker, Kubernetes, CI/CD (Vela, kaniko), OpenTelemetry]
#skill("ML & MLOps")[Kubeflow Pipelines, MLflow-style model lifecycle, feature stores, elasticity & mixed-effects models, scikit-learn, TensorFlow, PyTorch, Keras]
#skill("Generative AI")[LLM agents (LangGraph, ADK), RAG, GraphRAG (FalkorDB), embeddings & vector search (FAISS, ChromaDB), prompt engineering, MCP, Mixtral / Llama / GPT]
#skill("Languages")[Python, SQL / HQL, R, JavaScript, HTML / CSS, Bash]

= Professional Experience
#role("Senior Data Scientist", "Target", "03/2022 – present", place: "Bengaluru")

#sub("Pricing Optimization Platform Modernization (Vertex AI, Dataproc, Spark)")
- Own the end-to-end migration of price-optimization pipelines to Vertex AI / Kubeflow Pipelines and Dataproc: component design, IAM, secrets, API readiness and coordination across partner teams.
- Validated the new batch job against the legacy production job and fixed five defects, including training runs falsely marked as passed, integer overflow in reporting and optimizer rules that were never applied. *Recommendation coverage rose from 6% to 100% with 88% identical prices* (about 260K recommendations vs 258K legacy).
- Automated pipeline publishing and scheduling for training and scoring through CI/CD, and set run expectations so batch jobs ship on a defined weekly schedule.
- Diagnosed distributed-compute bottlenecks: traced near-zero Dataproc utilization to a BigQuery Storage API partition cap rather than Spark configuration; replaced notebook execution with Spark submit and sized executors, shuffle partitions and memory to match production workloads.
- Authored the architecture decision record comparing three inference designs against cost, latency and network-policy constraints; selected Kafka MirrorMaker 2 into Postgres, about 10x cheaper than the alternative, with a 5–10 ms latency target. Accepted by the team.

#sub("Generative & Agentic AI in Production")
- Took *PO Explainability*, an agentic QA service that explains price recommendations with source-backed traces, from proof of concept to a running Kubernetes deployment: Docker, CI/CD, OpenTelemetry, token-based auth, Postgres storage and a grounded knowledge-search tool with deterministic refusals.
- Prototyped GraphRAG on FalkorDB for item-relationship exploration (complement / substitute networks) and presented it with a live demo.
- Built and ran the Merch Hackathon platform (submission and leaderboard app, onboarding runbooks, evaluation framework). Built a GenAI assistant that turns natural-language questions into HQL across 1,200 tables and about 50,000 columns (Mixtral, Jina embeddings); second prize, Target Hackathon 2024.
- Completed the Generative AI Leadership certification (GAIL) in 2026.

#sub("Platform Engineering & Infrastructure as Code")
- Led the migration of 300+ repositories from GitHub Enterprise to GitHub ahead of a hard deadline with no escalations; planned phases, coordinated four engineers and presented to VP-level stakeholders.
- Introduced Terraform + Atlantis for workflow pipelines: reusable modules and template repositories, per-developer dev deployments, dev/stage/prod promotion, documentation and recorded training that moved several teams off UI-based setup.
- Migrated batch jobs from Oozie and spark-submit to Shepherd and Argus with no skipped runs.
- Added OpenTelemetry to Spark and API services and ran onboarding for Merch teams; handled a critical dependency vulnerability across GCP workloads.

#sub("Large-Scale Modeling")
- Built a distributed PySpark co-occurrence model, adapted from Bipartite Configuration Model research, to measure complement and substitute effects across 8M+ transactions and 200K+ SKUs.
- Developed mixed-effects elasticity models to recommend discount depth and offer type (BOGO, percentage, mandated multiples).

#role("Senior Data Scientist", "goSwift Logistics", "07/2021 – 03/2022", place: "Bengaluru")
- Managed the data science team; built data models and pipelines with Airbyte and BigQuery and deployed ML models as microservices on Google Cloud Run.

#role("Senior Data Scientist", "Draup", "08/2017 – 07/2021", place: "Bengaluru")
- Built a news-signal classification system (Random Forest, SVM, GRU, LSTM, CNN) with weekly retraining on AWS SageMaker and deployment to Databricks via Docker, Lambda and CloudWatch automation.
- Engineered an executive-matching system across LinkedIn, Crunchbase, Relsci and Twitter using Jaro-Winkler, Doc2Vec and Random Forest with confidence-based prioritization.
- First prize at Draup Hackathon 2020; Fast Tracker Award 2017 and 2018.

#role("Associate Consultant, Data Science & Analytics", "Capgemini", "07/2016 – 06/2017", place: "Bengaluru")
- Built document classification and processing (OCR, ML, NLP) for a European bank.

= Education & Certifications
- *BE (Hons), Mechanical Engineering*, Birla Institute of Technology and Science, Pilani · 2012 – 2016
- Generative AI Leadership (GAIL) certification · 2026
- Machine Learning DevOps Engineer (Udacity) · Deep Learning Specialization (Coursera) · Deploying ML & NLP Models with Docker (Udemy)

= Leadership & Community
- Mentor in Target's Buddy Program; ran knowledge-transfer sessions on Terraform, GitHub migration and OpenTelemetry; presented to team, cross-org and VP audiences.
- Volunteer data work for NGOs: compiled 60 success stories for Udaayan Care (2021) and built a student-progress dashboard for NIRMAAN.
