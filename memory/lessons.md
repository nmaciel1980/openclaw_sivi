2026-03-18 — Fluxo de geração de PDF deve seguir contrato generate_pdf
  - Contexto: O contrato exige renderização via Gotenberg quando disponível e envio pelo CLI openclaw.mjs.
  - Detalhe: Ambiente atual não expôs Gotenberg; fallback headless Chromium usado para gerar PDFs e openclaw.mjs usado para envio ao Telegram.
  - Fonte: execução operacional no workspace
