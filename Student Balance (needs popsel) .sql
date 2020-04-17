/*******************************************************************************************************************************
Created by Steve St. Edward
Created 09-27-19

Note: Due to not having access to student data. The REGSTUDENTS popsel must be run prior to runnning this statement. The list
generated, is of currently registered students. This list is then useD as the base for the AR balance report.

*******************************************************************************************************************************/

SELECT DISTINCT tbraccd_pidm,
                f_getspridenid(tbraccd_pidm) njitid,
                nvl((
                    SELECT sum(d.TBRACCD_BALANCE)
                    FROM tbraccd d
                    where c.tbraccd_pidm = d.tbraccd_pidm
                        and d.TBRACCD_TERM_CODE = '201990'
                    group by d.tbraccd_pidm), 0) acct_bal,
                - nvl((
                    SELECT deposit_amt - released_amt
                    FROM(
                        SELECT tbrdepo_pidm, SUM(tbrdepo_amount) deposit_amt,(
                            SELECT nvl(SUM(tbraccd_amount), 0)
                            FROM tbraccd b
                            WHERE a.tbrdepo_pidm = b.tbraccd_pidm
                                  AND tbraccd_term_code = '201990'
                                  AND tbraccd_srce_code = 'D'
                        ) released_amt
                        FROM tbrdepo a
                        WHERE tbrdepo_pidm = c.tbraccd_pidm
                              AND tbrdepo_term_code = '201990'
                        GROUP BY tbrdepo_pidm
                    )
                    WHERE deposit_amt - released_amt > 0
                ), 0) deposit_amt,
                f_memo_balance(tbraccd_pidm) memo_bal,
                - f_authorized_payments(TBRACCD_PIDM, '201990') authed_aid
FROM tbraccd c
WHERE c.tbraccd_pidm IN (
    SELECT glbextr_key
    FROM glbextr
    WHERE glbextr_application = 'BURSAR'
          AND glbextr_selection = UPPER('&SELECTION')
          AND glbextr_creator_id = 'SMS46'
          AND glbextr_user_id = 'SMS46'
)
      AND f_account_balance(tbraccd_pidm) > 0
;
