# AI Policy

This document was made to address the prevalent use of AI these days, specifically AI agents and LLMs alike

"This repository" refers specifically to the Posit-92 (WASM) GitHub repository

"Human contributor" here refers to the human person who actively participates in maintaining this repository

## Code commits

This section explains what things that are allowed to commit if you choose to use an AI agent, whether it be GPT 6 Astra, Claude Code, DeepSeek,Cursor agent, or whatever LLM you use

> 10 auto-generated lines can be more dangerous than 500 if nobody understands them

AI-assisted contributions are **allowed**, but the human contributor must:

- Understand the commit
- Test thoroughly of the code committed
- Test the compilation and runtime
- Take responsibility for what they submit
- Understand the maintainability cost including possible regressions
- Find a reason for the diff to be justifiable

These are a few review questions that deliberately increase friction for large or basically poorly understood AI-generated changes:

- "Can you explain the diff?"
- "Have you tested if it actually compiles & runs without errors?"
- "What makes you think this fits in the scope of a problem that you tried to fix?"
- "Are you sure this would benefit in the long run, and why?"
- "Do you take any responsibility of your commit, including regressions?"
- "Can you explain the maintenance tradeoff?"

I know AI detection is unreliable, so I chose the **demonstrated understanding** approach because it is observable
