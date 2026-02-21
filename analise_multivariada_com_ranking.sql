-- Análise Multivariada
-- Calculo do valor total dos lançamentos
-- Calculo da média dos lançamentos
-- Calculo da contagem dos lançamentos
-- Calculo da média do valor de taxa de conversão somente se a moeda for diferente de BRL
-- Criação ranking por valor total dos lançamentos, por média do valor dos lançamentos e por média da taxa de conversão, com resultado somente se o centro de custo for Compras ou RH 

SELECT 
	centro_custo,
	SUM(valor) as valor_total,
	RANK() OVER(ORDER BY SUM(valor) DESC) AS Rank_valor_total,
	moeda,
	ROUND(AVG(valor), 2) as media_lancamentos,
	RANK() OVER( ORDER BY ROUND(AVG(valor),2) DESC) AS Rank_media,
	COUNT(id) AS contagem_lancamentos,
	CASE WHEN moeda <> 'BRL' THEN ROUND(AVG(taxa_conversao),2) ELSE 0 END AS taxa_conversao_outras_moedas,
	RANK() OVER(ORDER BY CASE WHEN moeda <> 'BRL' THEN ROUND(AVG(taxa_conversao),2) ELSE 0 END) AS Rank_taxa
FROM esquema.lancamentosdsacontabeis

WHERE centro_custo = 'Compras' OR centro_custo = 'RH'
GROUP BY centro_custo, moeda
ORDER BY Rank_valor_total, Rank_media, Rank_taxa DESC;
