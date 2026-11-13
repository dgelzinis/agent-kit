# Problem pack: features that call an AI model

**Standards:** OWASP Top 10 for LLM Applications (genai.owasp.org) for the risks; the model provider's own docs for limits, structured output and safety settings (they change often: check the current docs).

## Trust boundaries
- Everything the model reads that a user or a document supplied is untrusted, and so is everything the model writes. Text in a document or message can try to give the model instructions (prompt injection).
- The model never gets more access than the user who triggered it. Tools and data it can reach are scoped to that user and that record.
- Model output is data: validate it against a schema before using it, escape it before showing it, and never run it as code, SQL or a command.
- Anything that changes money, data or sends a message is proposed by the model and confirmed by the user or checked by plain code. Arithmetic is done by the app, not the model.

## Privacy
- Send the least personal data that works; strip names, ids, account numbers and addresses when the task does not need them. Say in the product what is sent.
- No secrets or other users' data in prompts. Do not log prompts or outputs that contain personal data.

## Cost and reliability
- Per-user and global rate limits and a spend cap; cache identical requests; a hard limit on input size and output length.
- Timeouts and a clear fallback when the model is slow, down or refuses: the feature degrades, the app does not break.
- Ask for structured output (JSON with a schema) rather than parsing prose. Handle malformed and empty answers.
- The model name and settings are configuration, not scattered constants. Pin a version; changing it is a tested change.

## Quality
- Keep a small set of real example inputs with expected properties of the answer, and run it when the prompt or model changes.
- Tell the user it is AI-generated where it matters, show what it was based on, and make it easy to correct. Never present a guess as a fact, especially about money, health or law.
