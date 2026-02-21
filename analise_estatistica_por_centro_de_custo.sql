-- Sumarização de Dados
-- Objetivo: Criar uma query mostrando diversas métricas por centro de custo
-- A query deve mostrar: contagem_lancamentos, total_valores_lançamentos, media_valores_lançamentos, maior_valor, menor_valor, soma_valores_usd, soma_valores_eur, soma_valores_brl, media_taxa_conversao e mediana_valores
-- A query deve ser ordenada por total_valores_lançamentos em ordem decrescente

SELECT
	centro_custo,
	COUNT(id) AS contagem_lançamentos,
	SUM (valor) AS total_valores_lançamentos,
	AVG (valor) AS media_valores_lançamentos,
	MAX (valor) AS maior_valor,
	MIN (valor) AS menor_valor,
	SUM (CASE WHEN moeda = 'USD' THEN valor ELSE 0 END) AS soma_valores_usd,
	SUM (CASE WHEN moeda = 'EUR' THEN valor ELSE 0 END) AS soma_valores_eur,
	ROUND(AVG(CASE WHEN taxa_conversao IS NOT NULL THEN taxa_conversao ELSE 0 END), 2),
	PERCENTILE_CONT (0.5) WITHIN GROUP (ORDER BY valor) as mediana_valores
From esquema.lancamentosdsacontabeis
GROUP BY centro_custo
ORDER BY total_valores_lançamentos DESC;

