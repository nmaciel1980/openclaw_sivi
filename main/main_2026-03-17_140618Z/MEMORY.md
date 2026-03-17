# SIVI — Memory

Este arquivo é um índice curto da memória do workspace.
Ele não deve duplicar conteúdo dos arquivos de memória.

## Objetivo
Usar memória para melhorar respostas futuras sem inflar contexto.
Buscar sob demanda quando necessário.

## Regras de retenção
Consolidar apenas o que:
- melhora respostas futuras
- é estável
- tem utilidade recorrente
- reduz retrabalho
- não gera ruído

## Não consolidar
- testes temporários
- erros passageiros
- rascunhos descartados
- detalhes efêmeros sem valor futuro
- decisões ainda não consolidadas

## Regra de prudência
Na dúvida entre guardar ou não guardar, prefira não guardar.

## Índice local

### Memória curada principal
- `memory/decisions.md` -> decisões consolidadas
- `memory/state-changes.md` -> mudanças de configuração, estrutura e comportamento
- `memory/lessons.md` -> aprendizados reutilizáveis
- `memory/blockers.md` -> bloqueios e pendências
- `memory/key-facts.md` -> fatos estáveis

### Sessões
- `memory/sessions/` -> notas por data, bruto e compactações

### Projetos
- `memory/projects/` -> um arquivo por projeto relevante

## Contexto compartilhado
- `shared/outputs/` -> resultados interagente
- `shared/lessons/` -> aprendizados transversais do time
- usar shared de forma mínima e curada

## Regra de uso
- usar este arquivo como mapa
- não carregar toda a memória por padrão
- preferir memória curada para fatos estáveis
- usar sessões para histórico bruto
- usar shared apenas para contexto realmente compartilhado