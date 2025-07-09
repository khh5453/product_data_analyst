-- 10개 행 데이터만 가져와보기
-- SELECT *
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- LIMIT 10;

-- 데이터 행 개수 세보기
-- SELECT COUNT(*)
-- FROM  pelagic-campus-464902-b9.modulabs_project.data;

-- 각 컬럼별 데이터 수 세보기
-- Description, CustomerID 에 결측치 존재
-- SELECT COUNT(InvoiceNo) COUNT_InvoiceNo, COUNT(StockCode) COUNT_StockCode, COUNT(Description) COUNT_Description, COUNT(Quantity) COUNT_Quantity,
--       COUNT(InvoiceDate) COUNT_InvoiceDate, COUNT(UnitPrice) COUNT_UnitPrice, COUNT(CustomerID) COUNT_CustomerID, COUNT(Country) COUNT_Country
-- FROM pelagic-campus-464902-b9.modulabs_project.data;

-- 컬럼 별 누락된 값의 비율 계산
-- SELECT
--     'InvoiceNo' AS column_name,
--     ROUND(SUM(CASE WHEN InvoiceNo IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- UNION ALL
-- SELECT
--     'StockCode' AS column_name,
--     ROUND(SUM(CASE WHEN StockCode IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- UNION ALL
-- SELECT
--     'Description' AS column_name,
--     ROUND(SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- UNION ALL
-- SELECT
--     'Quantity' AS column_name,
--     ROUND(SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- UNION ALL
-- SELECT
--     'InvoiceDate' AS column_name,
--     ROUND(SUM(CASE WHEN InvoiceDate IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- UNION ALL
-- SELECT
--     'UnitPrice' AS column_name,
--     ROUND(SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- UNION ALL
-- SELECT
--     'CustomerID' AS column_name,
--     ROUND(SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- UNION ALL
-- SELECT
--     'Country' AS column_name,
--     ROUND(SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
-- FROM pelagic-campus-464902-b9.modulabs_project.data;

-- 이렇게 각 컬럼들 마다의 개수랑 총 개수 구해서 UNION 한 후 서브쿼리로 넣어서도 할 수 있다
-- SELECT column_name, ROUND((total - column_value) / total * 100, 2)
-- FROM
-- (
--     SELECT 'InvoiceNo' AS column_name, COUNT(InvoiceNo) AS column_value, COUNT(*) AS total FROM pelagic-campus-464902-b9.modulabs_project.data UNION ALL
--     SELECT 'StockCode' AS column_name, COUNT(StockCode) AS column_value, COUNT(*) AS total FROM pelagic-campus-464902-b9.modulabs_project.data UNION ALL
--     SELECT 'Description' AS column_name, COUNT(Description) AS column_value, COUNT(*) AS total FROM pelagic-campus-464902-b9.modulabs_project.data UNION ALL
--     SELECT 'Quantity' AS column_name, COUNT(Quantity) AS column_value, COUNT(*) AS total FROM pelagic-campus-464902-b9.modulabs_project.data UNION ALL
--     SELECT 'InvoiceDate' AS column_name, COUNT(InvoiceDate) AS column_value, COUNT(*) AS total FROM pelagic-campus-464902-b9.modulabs_project.data UNION ALL
--     SELECT 'UnitPrice' AS column_name, COUNT(UnitPrice) AS column_value, COUNT(*) AS total FROM pelagic-campus-464902-b9.modulabs_project.data UNION ALL
--     SELECT 'CustomerID' AS column_name, COUNT(CustomerID) AS column_value, COUNT(*) AS total FROM pelagic-campus-464902-b9.modulabs_project.data UNION ALL
--     SELECT 'Country' AS column_name, COUNT(Country) AS column_value, COUNT(*) AS total FROM pelagic-campus-464902-b9.modulabs_project.data
-- ) AS column_data;
--> 결측치 비율을 보면 CustomerID가 24.93%로 상당이 높음 -> 큰 비율의 누락된 값을 다른 값으로 대체하는 것은 분석에 상당한 편향을 주고 노이즈가 될 수 있으므로 CustomerID가 누락된 행 제거

-- Description 결측치 처리하기
-- 아래의 코드를 실행한 결과 같은 StockCode라도 Description이 다른 경우가 있음을 알 수 있음
-- 따라서 Description의 결측치를 같은 StockCode의 값으로 대체했을 때 신뢰하기 어렵고, Description의 결측 비율이 0.27%로 낮기 때문에 결측행을 제거하기로 함
-- SELECT DISTINCT Description
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- WHERE StockCode = '85123A';

-- 결측치 처리하기
-- DELETE FROM pelagic-campus-464902-b9.modulabs_project.data
-- WHERE CustomerID IS NULL OR Description IS NULL;


-- 중복값 확인하기
-- SELECT *
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- GROUP BY InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
-- HAVING COUNT(*) > 1;
--> 동일한 거래 시간을 포함한 동일한 행은 데이터 오류일 가능성이 높으므로 분석 결과에 영향을 줄 수 있음 -> 중복값 제거하기

-- 중복값 처리하기
-- CREATE OR REPLACE TABLE pelagic-campus-464902-b9.modulabs_project.data AS
-- SELECT DISTINCT *
-- FROM pelagic-campus-464902-b9.modulabs_project.data;

-- 중복 제거 후 데이터 개수
-- SELECT COUNT(*)
-- FROM pelagic-campus-464902-b9.modulabs_project.data;



-- InvoiceNo 컬럼 살펴보기
-- 고유(unique)한 InvoiceNo 출력하기
-- SELECT DISTINCT InvoiceNo
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- LIMIT 100;

-- InvoiceNo에 C로 시작하는 값들이 있음 -> 취소된 거래를 의미하므로 해당 행들 살펴보자
-- SELECT *
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- WHERE InvoiceNo LIKE 'C%'
-- LIMIT 100;
--> InvoiceNo에 C로 시작하는 값들의 특징을 보면 Quantity가 음수임을 알 수 있음

-- 구매 건 상태가 Canceled 인 데이터의 비율(%) 구해보기
-- SELECT ROUND(SUM(CASE WHEN InvoiceNo LIKE 'C%' THEN 1 ELSE 0 END)/ COUNT(InvoiceNo) * 100, 1) 
-- FROM pelagic-campus-464902-b9.modulabs_project.data;



-- StockCode 컬럼 살펴보기
-- 고유한 StockCode의 개수를 출력
-- SELECT COUNT(DISTINCT StockCode)
-- FROM pelagic-campus-464902-b9.modulabs_project.data;

-- 어떤 제품이 가장 많이 판매되었는지 보기 위하여 StockCode 별 등장 빈도를 출력해보기 (상위 10개의 제품 출력)
-- SELECT StockCode, COUNT(*) AS sell_cnt 
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- GROUP BY StockCode
-- ORDER BY sell_cnt DESC
-- LIMIT 10;
--> 제품 코드는 대부분 5~6자리의 숫자와 문자 조합으로 구성되어 있는 반면, 'POST'와 같은 몇 가지 이상한 코드도 있음


-- 'POST'와 같은 비정상적인 항목들은 숫자가 0개 포함되어 있으므로 StockCode 내 숫자의 개수를 살펴보기
-- WITH UniqueStockCodes AS (
--   SELECT DISTINCT StockCode
--   FROM pelagic-campus-464902-b9.modulabs_project.data
-- )
-- SELECT
--   LENGTH(StockCode) - LENGTH(REGEXP_REPLACE(StockCode, r'[0-9]', '')) AS number_count,
--   COUNT(*) AS stock_cnt
-- FROM UniqueStockCodes
-- GROUP BY number_count
-- ORDER BY stock_cnt DESC;
--> 쿼리 실행 결과 8개를 제외하곤 StockCode에 5개의 숫자들이 포함되어 있음을 알 수 있음
/* 
- LENGTH(REGEXP_REPLACE(StockCode, r'[0-9]', '')) : StockCode에서 숫자를 모두 ''로 대체한 후 길이를 재는 코드 -> 문자만 남기고 그 길이를 재는 것
- 빅쿼리에서는 쿼리 최적화 과정을 통해 GROUP BY에 SELECT 절에 정의한 별칭을 사용해도 오류가 나지 않음
  이는 DBMS마다 다르기 때문에 정확하게 사용하려면 별칭 말고 LENGTH(StockCode) - LENGTH(REGEXP_REPLACE(StockCode, r'[0-9]', '')) 이 부분을 group by에 써줘야 함 
  -> 쿼리 실행 순서가 SELECT 절이 GROUP BY 절보다 뒤에 실행되기 때문
*/

-- 숫자가 0~1개인 값들에는 어떤 코드들이 들어가 있는지를 확인하기
-- SELECT DISTINCT StockCode, number_count
-- FROM (
--   SELECT StockCode,
--     LENGTH(StockCode) - LENGTH(REGEXP_REPLACE(StockCode, r'[0-9]', '')) AS number_count
--   FROM pelagic-campus-464902-b9.modulabs_project.data
-- ) 
-- WHERE number_count <=1;


-- 해당 코드 값들을 가지고 있는 데이터 수는 전체 데이터 수 대비 몇 퍼센트일지 소수점 두번째 자리까지 구하기
-- SELECT ROUND((SELECT COUNT(StockCode) code_cnt
--         FROM pelagic-campus-464902-b9.modulabs_project.data
--         WHERE StockCode IN ('POST', 'D', 'C2', 'M', 'BANK CHARGES', 'PADS', 'DOT', 'CRUK')) / COUNT(*) * 100, 2)
-- FROM pelagic-campus-464902-b9.modulabs_project.data;

-- 제품과 관련되지 않은 거래 기록을 제거하기
-- DELETE FROM pelagic-campus-464902-b9.modulabs_project.data
-- WHERE StockCode IN (
--   SELECT DISTINCT StockCode
--   FROM (
--     SELECT StockCode,
--       LENGTH(StockCode) - LENGTH(REGEXP_REPLACE(StockCode, r'[0-9]', '')) AS number_count
--     FROM pelagic-campus-464902-b9.modulabs_project.data
--   ) 
--   WHERE number_count <=1
-- );


-- Description 살펴보기
-- 고유한 Description 별 출현 빈도를 계산하고 상위 30개를 출력하기
-- SELECT Description, COUNT(Description) AS description_cnt
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- GROUP BY Description
-- ORDER BY description_cnt DESC
-- LIMIT 30;

-- 대소문자가 혼합된 값이 있는지 확인하기
-- SELECT DISTINCT Description
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- WHERE REGEXP_CONTAINS(Description, r'[a-z]');  -- 소문자 포함 여부 확인

-- 서비스 관련 정보를 포함하는 행들을 제거
-- DELETE FROM pelagic-campus-464902-b9.modulabs_project.data
-- WHERE Description IN ('High Resolution Image', 'Next Day Carriage');

-- 대소문자를 혼합하고 있는 데이터를 대문자로 표준화하기
-- CREATE OR REPLACE TABLE pelagic-campus-464902-b9.modulabs_project.data AS
-- SELECT
--   * EXCEPT (Description),  -- 테이블의 모든 컬럼들을 가져오되, Description은 제외하라는 의미
--   UPPER(Description) AS Description 
-- FROM pelagic-campus-464902-b9.modulabs_project.data;


-- UnitPrice 살펴보기
-- UnitPrice의 최솟값, 최댓값, 평균구하기
-- SELECT MIN(UnitPrice) AS min_price, MAX(UnitPrice) AS max_price, AVG(UnitPrice) AS avg_price
-- FROM pelagic-campus-464902-b9.modulabs_project.data;

-- 단가가 0원인 거래의 개수, 구매 수량(Quantity)의 최솟값, 최댓값, 평균구하기
-- SELECT COUNT(*) AS cnt_quantity, MIN(Quantity) AS min_quantity, MAX(Quantity) AS max_quantity, AVG(Quantity) AS avg_quantity
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- WHERE UnitPrice = 0;

-- 무료 제품이라기 보다는 데이터 오류로 보이므로 제거하기
-- CREATE OR REPLACE TABLE pelagic-campus-464902-b9.modulabs_project.data AS 
-- SELECT *
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- WHERE UnitPrice != 0;




-- RFM 스코어 구하기
-- 1. Recency
-- InvoiceDate 컬럼을 연월일 자료형으로 변경하기
-- SELECT DATE(InvoiceDate) AS InvoiceDay, *
-- FROM pelagic-campus-464902-b9.modulabs_project.data

-- 최근 구매 일자를 MAX() 함수로 찾아보기
-- SELECT MAX(InvoiceDate) OVER() AS most_recent_date, 
--       DATE(InvoiceDate) AS InvoiceDay, *
-- FROM pelagic-campus-464902-b9.modulabs_project.data;

-- 유저 별로 가장 큰 InvoiceDay를 찾아서 가장 최근 구매일로 저장하기
-- SELECT 
--     CustomerID,
--     DATE(MAX(InvoiceDate)) AS InvoiceDay
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- GROUP BY CustomerID;

-- 가장 최근 일자(most_recent_date)와 유저별 마지막 구매일(InvoiceDay)간의 차이를 계산하기
-- SELECT
--   CustomerID, 
--   EXTRACT(DAY FROM MAX(InvoiceDay) OVER () - InvoiceDay) AS recency
-- FROM (
--   SELECT 
--     CustomerID,
--     MAX(DATE(InvoiceDate)) AS InvoiceDay
--   FROM pelagic-campus-464902-b9.modulabs_project.data
--   GROUP BY CustomerID
-- );



-- 지금까지의 결과를 user_r이라는 이름의 테이블로 저장하기
-- CREATE OR REPLACE TABLE pelagic-campus-464902-b9.modulabs_project.user_r AS
-- SELECT
--   CustomerID, 
--   EXTRACT(DAY FROM MAX(InvoiceDay) OVER () - InvoiceDay) AS recency
-- FROM (
--   SELECT 
--     CustomerID,
--     MAX(DATE(InvoiceDate)) AS InvoiceDay
--   FROM pelagic-campus-464902-b9.modulabs_project.data
--   GROUP BY CustomerID
-- );


-- 2. Frequency
-- 전체 거래 건수 계산 -> 고객마다 고유한 InvoiceNo의 수
-- SELECT
--   CustomerID,
--   COUNT(DISTINCT InvoiceNo) AS purchase_cnt
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- GROUP BY CustomerID;

-- 구매한 아이템의 총 수량 계산 -> 각 고객 별로 구매한 아이템의 총 수량
-- SELECT
--   CustomerID,
--   SUM(Quantity) AS item_cnt
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- GROUP BY CustomerID;

-- '1. 전체 거래 건수 계산'과 '2. 구매한 아이템의 총 수량 계산'의 결과를 합쳐서 user_rf라는 이름의 테이블에 저장하기
-- CREATE OR REPLACE TABLE pelagic-campus-464902-b9.modulabs_project.user_rf AS

-- -- (1) 전체 거래 건수 계산
-- WITH purchase_cnt AS ( 
--   SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS purchase_cnt
--   FROM pelagic-campus-464902-b9.modulabs_project.data
--   GROUP BY CustomerID
-- ),

-- -- (2) 구매한 아이템 총 수량 계산
-- item_cnt AS (
--   SELECT CustomerID, SUM(Quantity) AS item_cnt
--   FROM pelagic-campus-464902-b9.modulabs_project.data
--   GROUP BY CustomerID
-- )

-- -- 기존의 user_r에 (1)과 (2)를 통합
-- SELECT
--   pc.CustomerID,
--   pc.purchase_cnt,
--   ic.item_cnt,
--   ur.recency
-- FROM purchase_cnt AS pc
-- JOIN item_cnt AS ic
--   ON pc.CustomerID = ic.CustomerID
-- JOIN pelagic-campus-464902-b9.modulabs_project.user_r AS ur
--   ON pc.CustomerID = ur.CustomerID;


-- 3. Monetary
-- 고객별 총 지출액 계산(소수점 첫째 자리에서 반올림)
-- SELECT
--   CustomerID,
--   ROUND(SUM(UnitPrice * Quantity)) AS user_total
-- FROM pelagic-campus-464902-b9.modulabs_project.data
-- GROUP BY CustomerID;

-- 고객별 평균 거래 금액 계산
-- 1) data 테이블을 user_rf 테이블과 조인(LEFT JOIN) 한 후, 
-- 2) purchase_cnt로 나누어서 3) user_rfm 테이블로 저장
-- CREATE OR REPLACE TABLE pelagic-campus-464902-b9.modulabs_project.user_rfm AS   
-- SELECT
--   rf.CustomerID AS CustomerID,
--   rf.purchase_cnt,
--   rf.item_cnt,
--   rf.recency,
--   ut.user_total,
--   ROUND(ut.user_total / rf.purchase_cnt) AS user_average
-- FROM pelagic-campus-464902-b9.modulabs_project.user_rf rf
-- LEFT JOIN (
--   -- 고객 별 총 지출액
--   SELECT CustomerID, ROUND(SUM(UnitPrice * Quantity)) AS user_total
--   FROM pelagic-campus-464902-b9.modulabs_project.data
--   GROUP BY CustomerID
-- ) ut
-- ON rf.CustomerID = ut.CustomerID;

-- SELECT *
-- FROM pelagic-campus-464902-b9.modulabs_project.user_rfm
-- order by CustomerID;



-- 추가 Feature 추출
-- 1. 구매하는 제품의 다양성
--    1) 고객 별로 구매한 상품들의 고유한 수를 계산
--    2) user_rfm 테이블과 결과를 합치고
--    3) user_data라는 이름의 테이블에 저장
-- CREATE OR REPLACE TABLE pelagic-campus-464902-b9.modulabs_project.user_data AS  
-- WITH unique_products AS (
--   SELECT
--     CustomerID,
--     -- 고객 별로 구매한 상품들의 고유한 수
--     COUNT(DISTINCT StockCode) AS unique_products
--   FROM pelagic-campus-464902-b9.modulabs_project.data
--   GROUP BY CustomerID
-- )
-- SELECT ur.*, up.* EXCEPT (CustomerID)
-- FROM pelagic-campus-464902-b9.modulabs_project.user_rfm AS ur
-- JOIN unique_products AS up
-- ON ur.CustomerID = up.CustomerID;


-- 2. 평균 구매 주기
--평균 구매 소요 일수(고객들의 구매와 구매 사이의 기간이 평균적으로 몇 일인지를 보여주는 값)를 계산하고, 그 결과를 user_data에 통합
-- CREATE OR REPLACE TABLE pelagic-campus-464902-b9.modulabs_project.user_data AS 
-- WITH purchase_intervals AS (
--   -- (2) 고객 별 구매와 구매 사이의 평균 소요 일수
--   SELECT
--     CustomerID,
--     CASE WHEN ROUND(AVG(interval_), 2) IS NULL THEN 0 ELSE ROUND(AVG(interval_), 2) END AS average_interval
--   FROM (
--     -- (1) 구매와 구매 사이에 소요된 일수(현재 구매일에서 직전 구매일을 뺀 값)
--     SELECT
--       CustomerID,
--       DATE_DIFF(InvoiceDate, LAG(InvoiceDate) OVER (PARTITION BY CustomerID ORDER BY InvoiceDate), DAY) AS interval_
--     FROM
--       pelagic-campus-464902-b9.modulabs_project.data
--     WHERE CustomerID IS NOT NULL
--   )
--   GROUP BY CustomerID
-- )

-- SELECT u.*, pi.* EXCEPT (CustomerID)
-- FROM pelagic-campus-464902-b9.modulabs_project.user_data AS u
-- LEFT JOIN purchase_intervals AS pi
-- ON u.CustomerID = pi.CustomerID;



-- 3. 구매 취소 경향성
-- 취소 빈도 : 고객 별로 취소한 거래의 총 횟수
-- 취소 비율 : 각 고객이 한 모든 거래 중에서 취소를 한 거래의 비율
-- 취소 빈도와 취소 비율을 계산하고 그 결과를 user_data에 통합하기 (취소 비율은 소수점 두번째 자리까지 구하기)


-- CREATE OR REPLACE TABLE pelagic-campus-464902-b9.modulabs_project.user_data AS

-- WITH TransactionInfo AS (
--   SELECT
--     CustomerID,
--     COUNT(DISTINCT InvoiceNo) AS total_transactions, -- 전체 거래 횟수
--     COUNTIF(InvoiceNo LIKE 'C%') AS cancel_frequency
--   FROM pelagic-campus-464902-b9.modulabs_project.data
--   GROUP BY CustomerID
-- )

-- SELECT u.*, t.* EXCEPT(CustomerID), ROUND(t.cancel_frequency / t.total_transactions, 2) AS cancel_rate
-- FROM pelagic-campus-464902-b9.modulabs_project.user_data AS u
-- LEFT JOIN TransactionInfo AS t
-- ON u.CustomerID = t.CustomerID
-- order by CustomerID;






SELECT *
FROM pelagic-campus-464902-b9.modulabs_project.user_data;














