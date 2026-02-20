-- Identificação de Outliers
-- Vamos analisar a coluna valor
-- Para melhorar a análise, vamos observar os outliers por centro de custo e moeda
-- Para identificar outliers na tabela podemos usar uma abordagem baseada em Estatística, 
-- como calcular o intervalo interquartil (IQR) e identificar valores que estão significativamente 
-- acima ou abaixo desse intervalo. 
-- O IQR é a diferença entre o primeiro quartil (Q1, o 25º percentil) e o terceiro quartil (Q3, o 75º percentil). 
-- Os valores abaixo de Q1 - 0.5 * IQR ou acima de Q3 + 0.5 * IQR serão considerados outliers.
-- Crie a query que identifique os outliers (se existirem), por centro de custo e moeda.

SELECT COUNT(*) FROM esquema.lancamentosdsacontabeis;

SELECT 
    ROUND(AVG(valor),2) AS media, 
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY valor) AS mediana,
    MAX(valor) as maximo,
    MIN(VALOR) as minimo
FROM esquema.lancamentosdsacontabeis;

SELECT 
    centro_custo,
    moeda,
    MIN(VALOR) as minimo_valor,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY valor) AS q1,
    ROUND(AVG(valor),2) AS media_valor, 
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY valor) AS q2,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY valor) AS q3,
    MAX(valor) as maximo_valor
FROM
    esquema.lancamentosdsacontabeis
GROUP BY
    centro_custo, moeda;

SELECT 
    centro_custo,
    moeda,
    MIN(VALOR) as minimo_valor,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY valor) - 1.5 * (PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY valor) - PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY valor)) AS limite_inferior,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY valor) AS q1,
    ROUND(AVG(valor),2) AS media_valor, 
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY valor) AS q2,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY valor) AS q3,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY valor) + 1.5 * (PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY valor) - PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY valor)) AS limite_superior,
    MAX(valor) as maximo_valor
FROM
    esquema.lancamentosdsacontabeis
GROUP BY
    centro_custo, moeda;


--- Ajustando a multiplicação para um valor que seja condizente com os valores da tabela

SELECT 
    centro_custo,
    moeda,
    MIN(VALOR) as minimo_valor,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY valor) - 0.25 * (PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY valor) - PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY valor)) AS limite_inferior,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY valor) AS q1,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY valor) AS q2,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY valor) AS q3,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY valor) + 0.25 * (PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY valor) - PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY valor)) AS limite_superior,
    MAX(valor) as maximo_valor
FROM
    esquema.lancamentosdsacontabeis
GROUP BY
    centro_custo, moeda;


---Fazendo um filtro para trazer apenas os outliers

WITH Estatisticas AS (
    SELECT
        centro_custo,
        moeda,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY valor) AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY valor) AS q3
    FROM
       esquema.lancamentosdsacontabeis
    GROUP BY
        centro_custo, moeda
),
LimitesOutliers AS (
    SELECT
        centro_custo,
        moeda,
        q1,
        q3,
        q1 - 0.5 * (q3 - q1) AS limite_inferior,
        q3 + 0.5 * (q3 - q1) AS limite_superior
    FROM
        Estatisticas
)
SELECT
    L.id,
    L.data_lancamento,
    L.centro_custo,
    L.moeda,
    L.valor
FROM
    esquema.lancamentosdsacontabeis L

---Join do filtro com a tabela

INNER JOIN
    LimitesOutliers E
ON
    L.centro_custo = E.centro_custo AND L.moeda = E.moeda
WHERE
    L.valor < E.limite_inferior OR L.valor > E.limite_superior
ORDER BY
    L.valor, L.centro_custo, L.moeda
