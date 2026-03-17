# Contract — analyze_meeting_transcript

## finalidade
Contrato de análise de transcrição de reunião.

Uso principal:
- o fluxo externo envia uma transcrição já pronta
- o SIVI interpreta o conteúdo
- o retorno traz resumo estruturado e ações identificadas

## direção
Fluxo externo -> SIVI

## objetivo cognitivo do SIVI
Ao receber a transcrição, o SIVI deve:
- entender o contexto da reunião
- gerar resumo executivo
- listar principais pontos
- identificar ações
- separar ações de Nelson, de terceiros e sem responsável definido
- manter consistência com os responsáveis cadastrados quando essa lista vier no payload

## entrada lógica esperada
O contrato deve receber, no mínimo:
- identificador da reunião
- prompt ou instrução do fluxo chamador
- transcrição completa
- opcionalmente, lista de responsáveis cadastrados
- opcionalmente, instruções adicionais de classificação

## envelope esperado
    {
      "request_id": "uuid",
      "source": "n8n",
      "agent": "sivi",
      "action": "analyze_meeting_transcript",
      "data": {
        "id_reuniao": "REU-2026-0001",
        "prompt": "Resumo da reunião",
        "transcript": "texto completo da transcrição",
        "responsaveis_cadastrados": ["Nelson", "João", "Maria"]
      }
    }

## regras de interpretação
- não inventar fatos que não estejam sustentados pela transcrição
- não inventar responsável quando não houver evidência suficiente
- quando existir lista de responsáveis cadastrados, priorizar correspondência com essa lista
- ações de Nelson devem sair separadas das ações de terceiros
- ações sem responsável definido devem sair em bloco separado
- quando não houver data explícita para a ação, ela pode usar a data de referência da reunião no fluxo operacional posterior
- pendências operacionais não devem impedir a geração do resumo

## saída esperada
    {
      "success": true,
      "action": "analyze_meeting_transcript",
      "data": {
        "id_reuniao": "REU-2026-0001",
        "titulo": "Título curto da reunião",
        "descricao_curta": "Resumo curto em 1 ou 2 frases",
        "resumo_executivo": "Resumo executivo consolidado",
        "principais_pontos": [
          "Ponto 1",
          "Ponto 2"
        ],
        "acoes_nelson": [
          {
            "descricao": "Ação de Nelson",
            "prazo": "YYYY-MM-DD"
          }
        ],
        "acoes_terceiros": [
          {
            "descricao": "Ação de terceiro",
            "responsavel": "Nome",
            "prazo": "YYYY-MM-DD"
          }
        ],
        "acoes_sem_responsavel": [
          {
            "descricao": "Ação sem responsável definido",
            "prazo": "YYYY-MM-DD"
          }
        ]
      }
    }

## observações operacionais
- no runtime atual, esse contrato já está implementado no fluxo de entrada de áudio
- ações sem responsável podem ser registradas depois com responsável de placeholder, conforme regra operacional vigente
- saneamento posterior de responsável e prazo pode ocorrer sem necessidade de refazer o resumo

## regra de evolução
Se o payload real mudar no fluxo externo, este arquivo deve ser atualizado para continuar sendo a referência oficial do contrato.
