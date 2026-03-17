# Contract — register_nelson_tasks

## finalidade
Contrato para estruturar tarefas pessoais do Nelson em JSON para consumo por fluxo externo.

Uso principal:
- quando Nelson pedir para registrar, organizar ou enviar tarefas pessoais
- fora do fluxo de reunião
- sem registrar essas tarefas no banco operacional de reuniões e tarefas do SGT

## direção
SIVI -> fluxo externo

## objetivo cognitivo do SIVI
Ao preparar este contrato, o SIVI deve:
- identificar apenas tarefas pessoais do Nelson
- estruturar um payload limpo e consistente
- garantir que cada item tenha título claro, contexto útil e data quando disponível
- evitar misturar tarefas pessoais com ações operacionais de terceiros

## entrada lógica esperada
O contrato pode nascer de:
- pedido explícito de Nelson para registrar tarefas
- lista de ações pessoais organizada pelo próprio SIVI
- texto livre que precise ser convertido em tarefas estruturadas

## envelope esperado
    {
      "request_id": "uuid",
      "source": "openclaw",
      "agent": "sivi",
      "action": "register_nelson_tasks",
      "data": {
        "tasks": [
          {
            "title": "Título da tarefa",
            "notes": "Detalhes ou contexto",
            "due": "YYYY-MM-DD",
            "list": "SIVI"
          }
        ]
      }
    }

## formato de cada tarefa
Campos esperados por item:
- title: título curto e objetivo
- notes: contexto, detalhes, origem ou observação útil
- due: data no formato YYYY-MM-DD quando existir
- list: nome da lista de destino

## regras de interpretação
- usar apenas para tarefas pessoais do Nelson
- não misturar com ações de terceiros
- não usar este contrato para registrar tarefas de reunião no Postgres
- quando a data não estiver disponível, o campo pode ficar vazio ou seguir a regra operacional vigente do fluxo externo
- o campo list deve usar SIVI como padrão, salvo mudança futura decidida no projeto
- o título deve ser curto, claro e acionável
- notes deve carregar contexto suficiente para a automação ou revisão posterior

## saída esperada
    {
      "success": true,
      "action": "register_nelson_tasks",
      "data": {
        "tasks": [
          {
            "title": "Comprar insumos do almoxarifado",
            "notes": "Lembrar de revisar itens críticos",
            "due": "2026-03-18",
            "list": "SIVI"
          }
        ]
      }
    }

## observações operacionais
- este contrato existe para tarefas pessoais do Nelson
- o destino operacional exato é tratado fora do SIVI
- o SIVI deve se preocupar em entregar payload limpo e consistente

## regra de evolução
Se o formato operacional mudar, este arquivo deve ser atualizado para permanecer como referência oficial do contrato.
