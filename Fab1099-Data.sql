/***********************************************************************************
*Report created by looking up data in fab1099 and pulling in Account Code from check
*data
*
*
************************************************************************************/

SELECT "ID"           "ID",
       "Last_Name"    "Last_Name",
       "First_Name"   "First_Name",
       "State"        "State",
       farinva_acct_code "Account_Code",
       SUM(FARINVA_APPR_AMT) total
FROM (
    SELECT spriden_id           "ID",
           spriden_last_name    "Last_Name",
           spriden_first_name   "First_Name",
           (
               SELECT spraddr_stat_code
               FROM fabinvh g
               INNER JOIN spraddr ON ( fabinvh_vend_pidm = spraddr_pidm
                                       AND fabinvh_atyp_code = spraddr_atyp_code
                                       AND fabinvh_atyp_seq_num = spraddr_seqno )
               WHERE fabinvh_code = (select FABINCK_INVH_CODE
                   FROM fabinck h
                   WHERE fabinck_check_num = b.fab1099_check_num
                         AND ROWNUM = 1
                    )
           ) "State",
        --FAB1099_RPT_AMT
        farinva_acct_code,
        FARINVA_APPR_AMT
    FROM fab1099 b
    INNER JOIN (select SPRIDEN_ID,
               spriden_pidm,
               SPRIDEN_LAST_NAME,
               spriden_first_name
        FROM spriden
                        where SPRIDEN_CHANGE_IND IS NULL
              AND length(spriden_id) = 8
                        and translate(spriden_id, ' 1234567890','0') IS NULL
    ) ON fab1099_vend_pidm = spriden_pidm
    INNER JOIN (
        SELECT farinva_invh_code,
               farinva_acct_code,
               FARINVA_APPR_AMT
        FROM farinva
    ) ON farinva_invh_code = b.fab1099_invh_code
    WHERE fab1099_check_date BETWEEN '01-oct-18' AND '30-sep-19'
          AND fab1099_coas_code = '1'
          AND fab1099_cancel_ind IS NULL
)
GROUP BY "ID", "Last_Name", "First_Name", "State", farinva_acct_code;