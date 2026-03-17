# Contract — generate_pdf

## finalidade
Contrato para geração de PDF sob demanda a partir de conteúdo estruturado.

Uso principal:
- quando Nelson pedir um material em PDF
- fora do fluxo operacional já existente de reunião
- para documentos, resumos, relatórios ou materiais gerados no chat

## direção
SIVI -> renderizador HTTP de PDF

## objetivo cognitivo do SIVI
Ao preparar este contrato, o SIVI deve:
- organizar o conteúdo final
- preferir HTML quando o layout importar
- definir título e nome de arquivo coerentes
- enviar para renderização apenas quando o conteúdo já estiver pronto

## entrada lógica esperada
O contrato pode nascer de:
- pedido explícito para gerar PDF
- resumo já concluído
- relatório já estruturado
- conteúdo em texto ou HTML pronto para renderização

## envelope lógico esperado
    {
      "request_id": "uuid",
      "source": "openclaw",
      "agent": "sivi",
      "action": "generate_pdf",
      "data": {
        "title": "Título do documento",
        "filename": "nome-do-arquivo.pdf",
        "content_html": "<html><body><h1>Título</h1><p>Conteúdo</p></body></html>"
      }
    }

## campos esperados
- title: título do documento
- filename: nome final do arquivo PDF
- content_html: conteúdo em HTML quando o layout importar
- content_text: alternativa textual quando o fluxo aceitar conversão simples
- context: informações opcionais de formatação ou finalidade

## regras de interpretação
- usar este contrato para PDFs sob demanda
- preferir HTML quando houver necessidade de layout melhor
- não enviar para renderização conteúdo ainda incompleto
- manter o nome do arquivo limpo, curto e legível
- não misturar este contrato com fluxos operacionais maiores já tratados fora do SIVI
- detalhes de infraestrutura podem evoluir sem mudar a finalidade do contrato

## referência operacional atual
No runtime atual, a geração usa um renderizador HTTP compatível com Gotenberg.

Padrão atual de chamada:
- método HTTP: POST
- URL de referência no ambiente atual: http://gotenberg:3000/forms/chromium/convert/html
- autenticação: nenhuma
- tipo de envio: multipart/form-data
- campo do arquivo no form-data: files
- o arquivo HTML enviado para renderização deve se chamar index.html
- o nome final do PDF é definido no header Gotenberg-Output-Filename

## saída esperada
    {
      "success": true,
      "action": "generate_pdf",
      "data": {
        "filename": "nome-do-arquivo.pdf",
        "content_type": "application/pdf",
        "result": "pdf_gerado"
      }
    }

## observações operacionais
- este contrato descreve o caminho direto de geração de PDF sob demanda
- PDFs de reunião já seguem fluxo operacional próprio
- se a infraestrutura de renderização mudar, a finalidade do contrato continua a mesma

## regra de evolução
Se a forma de renderização mudar, este arquivo deve ser atualizado para permanecer como referência oficial do contrato.

REGRA OPERACIONAL OBRIGATÓRIA — PDF + TELEGRAM

Sempre que este fluxo gerar um PDF, o comportamento padrão deve ser:
1. gerar o arquivo PDF
2. salvar em caminho absoluto acessível no ambiente
3. enviar o PDF ao Telegram do usuário
4. só então confirmar sucesso

NÃO usar `sessions_send` com `[file:...]` para envio de documento no Telegram.
Esse método não deve ser usado para PDFs/documentos nesse fluxo.

Para enviar o PDF, usar a ferramenta de terminal/exec do ambiente atual e executar diretamente o CLI nativo do OpenClaw no diretório `/app`.

Comando padrão:
cd /app && node ./openclaw.mjs message send --channel telegram --account default --target 1326250955 --media "<caminho-absoluto-do-pdf>" --message "<legenda-do-arquivo>"

Regras de execução:
- localizar o diretório correto onde está `openclaw.mjs`
- executar o comando real, não apenas descrever o procedimento
- só considerar sucesso se o terminal retornar algo equivalente a `Sent via Telegram`
- capturar o `Message ID` retornado
- se houver erro, retornar o erro real do terminal
- informar também o caminho usado para o OpenClaw

Resposta final do fluxo deve seguir este formato:
- status: sucesso ou erro
- message_id: <id retornado>
- erro: <mensagem real ou none>
- caminho_openclaw: <caminho usado>
- pdf_path: <caminho absoluto do pdf>

Se `openclaw.mjs` não estiver no diretório atual, encontrar o caminho correto antes de executar.
Se o envio falhar, não afirmar que o arquivo foi enviado.
