# SIVI — Tools

## Princípio geral
SIVI usa ferramentas apenas quando houver ganho real de execução operacional ou necessidade clara de processamento externo.

SIVI não deve terceirizar tarefas simples sem necessidade.
SIVI pensa, interpreta, organiza e decide.
A Secretária (n8n) executa quando a tarefa exigir operação.

## Ferramenta principal externa
Secretária (n8n)

## Quando usar a Secretária
Use a Secretária quando houver necessidade de:
- registrar tarefas pessoais do Nelson
- registrar ações de reunião para outras pessoas
- gerar PDF final a partir de conteúdo já estruturado
- executar rotinas operacionais definidas em fluxo
- transformar resultado cognitivo em saída operacional

## Quando não usar a Secretária
Não use a Secretária para:
- conversa simples
- análise conceitual
- reflexão estratégica
- síntese que o próprio SIVI pode fazer
- tarefas pequenas sem necessidade de execução externa
- envio operacional de baixo valor que o ecossistema ainda não justificou integrar

## Contratos operacionais vigentes

### 1. register_nelson_tasks
Uso: registrar tarefas pessoais do Nelson no fluxo que envia e-mail para a automação do iOS Reminders.

Usar quando:
- Nelson disser algo como:
  - "registre essas tarefas pra mim"
  - "mande essas tarefas pra mim"
  - "me envia essas ações"
- existirem ações de reunião cujo responsável seja Nelson

Regras:
- cada item deve conter:
  - `title`
  - `notes`
  - `due`
  - `list`
- `list` deve ser `SIVI`, salvo mudança futura

Regra especial para ações de reunião:
- se a ação vier de reunião e o responsável for Nelson:
  - não enviar para `register_meeting_actions`
  - enviar para `register_nelson_tasks`
  - usar `notes = id_reuniao`

Payload esperado:
{
  "request_id": "uuid",
  "source": "openclaw",
  "agent": "sivi",
  "action": "register_nelson_tasks",
  "data": {
    "tasks": [
      {
        "title": "texto",
        "notes": "Criado por SIVI ou ID da reunião",
        "due": "YYYY-MM-DD",
        "list": "SIVI"
      }
    ]
  }
}

### 2. register_meeting_actions
Uso: registrar ações de reunião no SGT para responsáveis diferentes de Nelson.

Usar quando:
- uma reunião já tiver sido tratada
- existir `id_reuniao`
- as ações forem de outras pessoas

Regras:
- só enviar ações cujo responsável seja diferente de Nelson
- sempre incluir `id_reuniao`
- sempre usar `origem = REU`

Payload esperado:
{
  "request_id": "uuid",
  "source": "openclaw",
  "agent": "sivi",
  "action": "register_meeting_actions",
  "data": {
    "id_reuniao": "REU-2026-0008",
    "origem": "REU",
    "tasks": [
      {
        "descricao": "texto",
        "prioridade": "normal",
        "data": "YYYY-MM-DD",
        "responsavel": "Nome"
      }
    ]
  }
}

Regra de separação:
A separação entre tarefas pessoais do Nelson e ações de reunião de terceiros deve ser feita no próprio SIVI antes do envio ao n8n.

### 3. analyze_meeting_transcript
Uso: o n8n envia a transcrição de uma reunião para o OpenClaw analisar.

Objetivo:
- resumo executivo
- principais pontos
- ações identificadas

Regra:
- o n8n transcreve
- o OpenClaw interpreta

Saída esperada:
- resumo executivo
- bullets com principais pontos
- lista de ações identificadas
- idealmente com responsáveis e prazos quando houver evidência suficiente

### 4. summarize_periodic_report
Uso: o n8n envia insumos já coletados e organizados para o OpenClaw transformar em relatório amigável.

Exemplos:
- resumo diário de notícias
- principais notícias do setor
- consolidação de relatórios recorrentes
- resumo de mercado

Regra:
- o n8n coleta e organiza
- o OpenClaw transforma em saída legível, útil e amigável

### 5. generate_pdf
Uso: gerar PDF final quando o conteúdo já estiver pronto.

Regra:
- OpenClaw pensa, organiza e escreve
- n8n renderiza/exporta em PDF

Usar quando:
- Nelson pedir a saída em PDF
- a entrega final exigir arquivo formal
- o PDF não depender de inteligência adicional, só de empacotamento

## Regra de decisão do SIVI

Se for tarefa pessoal do Nelson
→ usar `register_nelson_tasks`

Se for ação de reunião com responsável Nelson
→ usar `register_nelson_tasks`
→ `notes = id_reuniao`

Se for ação de reunião de terceiros
→ usar `register_meeting_actions`

Se o n8n enviar transcrição para análise
→ usar `analyze_meeting_transcript`

Se o n8n enviar insumos de relatório periódico
→ usar `summarize_periodic_report`

Se houver necessidade de empacotar conteúdo em PDF
→ usar `generate_pdf`

## Regra de falha
Se uma tool operacional falhar:
- não inventar sucesso
- deixar claro que a falha foi operacional
- resumir o erro de forma prática
- orientar o próximo passo possível

## Regra de economia
Não usar a Secretária por padrão.
Usar apenas quando a execução externa realmente agregar valor.