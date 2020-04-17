

SELECT *
FROM ALL_OBJECTS
WHERE OBJECT_TYPE = 'TABLE';

/*******************************************************************************************************************************
Returns queues with funds that belong to specified financial managers
*******************************************************************************************************************************/

select distinct queueID.FORAQRC_QUEUE_ID
from FORAQRC queueID
where exists(
    select
        fund.ftvfund_coas_code,
        fund.ftvfund_fund_code
    from ftvfund fund
    where ftvfund_fmgr_code_pidm in (
        select     
            spriden_pidm
        from spriden
        where spriden_id in (
			--NJITID            
        )
            and FTVFUND_STATUS_IND = 'A'
            and fund.ftvfund_coas_code = queueID.FORAQRC_COAS_CODE
            and fund.ftvfund_fund_code = queueID.FORAQRC_FUND_CODE
    )
)
    and FORAQRC_DOC_TYPE = 3;

/*******************************************************************************************************************************
Returns the 8Digit NJITID
*******************************************************************************************************************************/

SELECT SPRIDEN_ID,
            SPRIDEN_PIDM,
            SPRIDEN_LAST_NAME,
            SPRIDEN_FIRST_NAME,
            SPRIDEN_ACTIVITY_DATE
        FROM SPRIDEN
        where length(SPRIDEN_ID) = 8
            and LENGTH(TRIM(TRANSLATE(SPRIDEN_ID, ' +-.0123456789',' '))) is null;

/*******************************************************************************************************************************
selects Open Blanket orders
*******************************************************************************************************************************/

select 
    FPBPOHD.*,
    SPRIDEN_ID,
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_ACTIVITY_DATE,
    FPRPODA_COAS_CODE, 
    FPRPODA_ACCI_CODE, 
    FPRPODA_FUND_CODE,   
    FPRPODA_ORGN_CODE,
    FPRPODA_PROG_CODE,   
    FPRPODA_ACTV_CODE,
    FPRPODA_LOCN_CODE,  
    FPRPODA_PROJ_CODE
from FPBPOHD 
    inner join FPRPODA on (FPBPOHD.FPBPOHD_CODE = FPRPODA.FPRPODA_POHD_CODE)
    inner join (
        SELECT 
            SPRIDEN_ID,
            SPRIDEN_PIDM,
            SPRIDEN_LAST_NAME,
            SPRIDEN_FIRST_NAME,
            SPRIDEN_ACTIVITY_DATE
        from SPRIDEN INNER JOIN FTVVEND
            ON (SPRIDEN.SPRIDEN_PIDM = FTVVEND.FTVVEND_PIDM)      
        where length(SPRIDEN_ID) = 8
    ) on (FPBPOHD.FPBPOHD_VEND_PIDM = SPRIDEN_PIDM)
where FPBPOHD_CLOSED_IND = 'N'
    and FPBPOHD_PO_TYPE_IND = 'S';


/*******************************************************************************************************************************
selects Org Hierarchy
*******************************************************************************************************************************/

select 
    FTVORGN_COAS_CODE,
    FTVORGN_ORGN_CODE,
    FTVORGN_TITLE,
    FTVORGN_ORGN_CODE_PRED,
    level,
    SYS_CONNECT_BY_PATH(FTVORGN_ORGN_CODE, '/') as Path
from (
    select *
    from FTVORGN
    where FTVORGN_COAS_CODE = '1' -- It is best to run the query by chart. it becomes rather difficult to manage multiple chart because of dupliacte orgs
        and FTVORGN_STATUS_IND = 'A'
        AND FTVORGN_TERM_DATE IS NULL
        AND FTVORGN_NCHG_DATE > CURRENT_DATE
    )
START WITH FTVORGN_ORGN_CODE = 'NJIT' -- Select the level that you would like to drill down under.
connect by prior FTVORGN_ORGN_CODE = FTVORGN_ORGN_CODE_PRED;

/*******************************************************************************************************************************
SELECTs the PO and REQ against a GL account
*******************************************************************************************************************************/

SELECT 
    FPBPOHD_NAME,
    FPBPOHD_COAS_CODE,
    FPBPOHD_ORGN_CODE,
    FTVRQPO_REQD_CODE,
    FPBPOHD_CODE,
    FPRPODA_COAS_CODE,
    FPRPODA_FUND_CODE,
    FPRPODA_ORGN_CODE,
    FPRPODA_ACCT_CODE,
    FPRPODA_PROG_CODE
FROM FPBPOHD FPRPODA
INNER JOIN (
     SELECT *
        FROM FPRPODA
        WHERE (FPRPODA_ACCT_CODE LIKE '1%'
        OR FPRPODA_ACCT_CODE LIKE '2%'
        OR FPRPODA_ACCT_CODE LIKE '9%')
        AND FPRPODA_POHD_CODE LIKE 'P17%'
    ) ON (FPBPOHD_CODE = FPRPODA_POHD_CODE)
LEFT JOIN FTVRQPO ON (FPBPOHD_CODE = FTVRQPO_POHD_CODE);

/*******************************************************************************************************************************
Invoice Data with Check number data
*******************************************************************************************************************************/

SELECT 
    FARINVA_INVH_CODE,
    FARINVA_POHD_CODE,
    FARINVA_COAS_CODE,
    FARINVA_ACCI_CODE,
    FARINVA_FUND_CODE,
    FARINVA_ORGN_CODE,
    FARINVA_ACCT_CODE,
    FABINCK_CHECK_NUM,
    FABINCK_NET_AMT
FROM FARINVA LEFT OUTER JOIN (
    SELECT 
        FABINCK_INVH_CODE,
        FABINCK_CHECK_NUM,
        FABINCK_NET_AMT
    FROM FABINCK
    WHERE FABINCK_INVH_CODE LIKE 'I17%'
) ON (FARINVA_INVH_CODE = FABINCK_INVH_CODE)
WHERE (FARINVA_ACCT_CODE LIKE '1%'
        OR FARINVA_ACCT_CODE LIKE '2%'
        OR FARINVA_ACCT_CODE LIKE '9%')
        AND FARINVA_INVH_CODE LIKE 'I17%'; 

/*******************************************************************************************************************************
Gets inception to date summary reimbursement data, received FROM Chrome River.
Provides the NJITID, Last Name, First Name, Invoice AND Amount
*******************************************************************************************************************************/
SELECT 
    SPRIDEN_ID,
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
	FABINVH_CODE,
    total
FROM FABINVH
    JOIN (
        SELECT SPRIDEN_ID,
            SPRIDEN_PIDM,
            SPRIDEN_LAST_NAME,
            SPRIDEN_FIRST_NAME
        FROM SPRIDEN
    ) ON FABINVH_VEND_PIDM = SPRIDEN_PIDM
    JOIN (
        SELECT
            FARINVA_INVH_CODE,
            sum(FARINVA_APPR_AMT) as total
        FROM FARINVA
        WHERE FARINVA_INVH_CODE LIKE 'TR%'
        GROUP BY FARINVA_INVH_CODE
    ) ON FABINVH_CODE = FARINVA_INVH_CODE 
WHERE FABINVH_CODE Like 'TR%';
--GROUP BY SPRIDEN_ID, SPRIDEN_LAST_NAME, SPRIDEN_FIRST_NAME

/*******************************************************************************************************************************
Active Indexes that can be used fOR purchases.
*******************************************************************************************************************************/

SELECT
	FTVACCI_COAS_CODE,
	FTVACCI_ACCI_CODE,
	FTVACCI_NCHG_DATE,
	FTVACCI_TERM_DATE,
	FTVACCI_TITLE,
	FTVACCI_STATUS_IND,
	FTVACCI_FUND_CODE,
	FTVACCI_ORGN_CODE,
	FTVACCI_ACCT_CODE,
	FTVACCI_PROG_CODE
FROM FTVACCI
	INNER JOIN (
		SELECT 
            FTVFUND_COAS_CODE,
            FTVFUND_FUND_CODE
		FROM FTVFUND
		WHERE FTVFUND_STATUS_IND = 'A' 
			AND (FTVFUND_TERM_DATE > CURRENT_DATE OR FTVFUND_TERM_DATE IS NULL) 
			AND FTVFUND_NCHG_DATE > CURRENT_DATE
	) ON (FTVACCI_COAS_CODE = FTVFUND_COAS_CODE AND FTVACCI_FUND_CODE = FTVFUND_FUND_CODE)
	INNER JOIN (
	SELECT
        FTVORGN_COAS_CODE,
        FTVORGN_ORGN_CODE
	FROM FTVORGN
	WHERE FTVORGN_STATUS_IND = 'A' 
		AND (FTVORGN_TERM_DATE > CURRENT_DATE OR FTVORGN_TERM_DATE IS NULL) 
		AND FTVORGN_NCHG_DATE > CURRENT_DATE		
	) ON (FTVACCI_COAS_CODE = FTVORGN_COAS_CODE AND  FTVACCI_ORGN_CODE = FTVORGN_ORGN_CODE)
WHERE FTVACCI_STATUS_IND = 'A' 
	AND (FTVACCI_TERM_DATE > CURRENT_DATE OR FTVACCI_TERM_DATE IS NULL) 
	AND FTVACCI_NCHG_DATE > CURRENT_DATE
	AND FTVACCI_PROG_CODE NOT IN ('450010','010000','600010');

/*******************************************************************************************************************************
Active account codes WHERE filterd by account type level 1
*******************************************************************************************************************************/
SELECT *
FROM ftvacct
WHERE FTVACCT_STATUS_IND = 'A' 
		AND (FTVACCT_TERM_DATE > CURRENT_DATE OR FTVACCT_TERM_DATE IS NULL) 
		AND FTVACCT_NCHG_DATE > CURRENT_DATE
        AND (length(ftvacct_acct_code) = 6)
        AND FTVACCT_DATA_ENTRY_IND = 'Y'
        AND FTVACCT_ATYP_CODE IN (
            SELECT FTVATYP_ATYP_CODE
            FROM FTVATYP
            WHERE FTVATYP_ATYP_CODE_PRED = '70'
            );

/*******************************************************************************************************************************
Lookup active approvals fOR a particular user.
*******************************************************************************************************************************/
SELECT * 
FROM FOBAINP JOIN FORAQUS 
ON (FOBAINP_QUEUE_ID = FORAQUS_QUEUE_ID 
    AND FOBAINP_LEVEL = FORAQUS_QUEUE_LEVEL)
WHERE FORAQUS.FORAQUS_USER_ID_APPR = 'HARTOUNI';

/*******************************************************************************************************************************
Identify PO AND PO type i.e. Standing vs Regular
*******************************************************************************************************************************/
SELECT 
    FPBPOHD_CODE,
    FPBPOHD_PO_TYPE_IND
FROM FPBPOHD
WHERE FPBPOHD_CODE LIKE 'P18%';