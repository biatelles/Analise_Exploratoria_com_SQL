-- Distribuição de Dados
-- Objetivo: Criar uma query para mostrar a distribuição de dados na tabela, com interesse na coluna valor.
-- O relatório deve mostrar: quantidade_lancamentos, media_valor, desvio_padrao_valor, menor_valor, maior_valor e primeiro, segundo e terceiro quartil.
-- Tudo isso por centro de custo e por moeda.

SELECT centro_custo,
	moeda,
	COUNT(id) AS quantidade_lancamentos,
	ROUND(AVG(valor), 2) AS media_valor,
	ROUND(STDDEV(valor),2) AS desvio_padrao,
	MIN (valor) AS menor_valor,
	MAX (valor) AS maior_valor,
	PERCENTILE_CONT (0.25) WITHIN GROUP (ORDER BY valor) AS primeiro_quartil,
	PERCENTILE_CONT (0.5) WITHIN GROUP (ORDER BY valor) AS segundo_quartil,
	PERCENTILE_CONT (0.75) WITHIN GROUP (ORDER BY valor) AS terceiro_quartil
FROM esquema.lancamentosdsacontabeis

GROUP BY centro_custo, moeda
ORDER BY centro_custo, moeda DESC
