# Memory

Este arquivo é um índice curto da memória do workspace.
Não duplicar conteúdo dos arquivos temáticos.

## Regra de retenção
Guardar apenas o que:
- melhora entregas futuras
- é estável
- reduz retrabalho
- ajuda o agente no seu próprio domínio

## Índice local
- `memory/decisions.md` -> decisões permanentes do agente
- `memory/state-changes.md` -> mudanças de configuração, estrutura ou comportamento
- `memory/lessons.md` -> lições e padrões reutilizáveis
- `memory/blockers.md` -> bloqueios e pendências
- `memory/key-facts.md` -> fatos estáveis do domínio
- `memory/sessions/` -> notas por data e contexto bruto
- `memory/projects/` -> projetos do domínio do agente

## Contexto compartilhado
- `shared/outputs/` -> usar só quando a saída precisar circular entre agentes
- `shared/lessons/` -> usar só para aprendizados realmente transversais

## Regra de uso
- usar este arquivo como mapa
- não carregar tudo por padrão
- consultar arquivos específicos sob demanda
- preferir memória curada
- usar sessões apenas como contexto bruto