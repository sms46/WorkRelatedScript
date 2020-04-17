/*******************************************************************************************************************************
Lookup active approvals fOR a particular user.
*******************************************************************************************************************************/
SELECT * 
FROM FOBAINP JOIN FORAQUS 
ON (FOBAINP_QUEUE_ID = FORAQUS_QUEUE_ID 
    AND FOBAINP_LEVEL = FORAQUS_QUEUE_LEVEL)
WHERE FORAQUS.FORAQUS_USER_ID_APPR = 'HARTOUNI';


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