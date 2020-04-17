SELECT *
from INTERNET_ADDRESS_CURRENT
where ENTITY_UID  = 206826;

-- SIS - Feb 02 2018. changed hold desc to hold reason as requested by Cheryl
-- SIS - May 09 2018  added 35 terms and fall 2018 terms
        SELECT spriden_pidm,
         spriden_id,
         spriden_first_name,
         spriden_last_name,
         sgbstdn_stst_code,
         sgbstdn_levl_code,
         (
             CASE
                 WHEN sgbstdn_levl_code = 'G'       THEN
                     'GR'
                 WHEN sgbstdn_levl_code = 'D'       THEN
                     'PHD'
                 WHEN hours_earned BETWEEN 0 AND 28 THEN
                     'FR'
                 WHEN hours_earned BETWEEN 29 AND 56 THEN
                     'SO'
                 WHEN hours_earned BETWEEN 57 AND 90 THEN
                     'JR'
                 WHEN hours_earned BETWEEN 91 AND 130 THEN
                     'SR'
                 WHEN hours_earned >= 131           THEN
                     'Y5'
                 ELSE
                     'FR'
             END
         ) student_class,
         overall_balance,
         balance_201590,
         balance_201710,
         balance_201750,
         balance_201790,
         balance_201810,
         balance_201835,
       balance_201850,
         balance_201890,
         balance_201895,
         balance_201910,
         balance_201950, -- Added by Snehal
         balance_201990, -- Added by Snehal
         balance_201995,
         balance_202010,
         hold_1,
         sprhold_reason_1,
         hold_2,
         sprhold_reason_2,
         hold_3,
         sprhold_reason_3,
         hold_4,
         hold_5,
         hold_6,
         hold_7,
         hold_8,
         hold_9,
         hold_10,
         tbbacct_deli_code   delinquency_code,
         ttvdeli_desc        delinquency_description,
         registered_201950, -- Added by Snehal
         withdrawn_201950, -- Added by Snehal
         total_201950, -- Added by Snehal
         registered_201990, -- Added by Snehal
         withdrawn_201990, -- Added by Snehal
         total_201990, -- Added by Snehal
         registered_202010,
         withdrawn_202010,
         total_202010,
         sgbstdn_resd_code   residency,
         visa_status         visa_type,
         njit_email_address,
         other_email_address,
         phone_number
  FROM spriden,
       sgbstdn a,
       (
           SELECT tbraccd_pidm,
                  SUM(tbraccd_balance) overall_balance,
                  SUM(
                      CASE
                          WHEN tbraccd_term_code = '201590' THEN
                              tbraccd_balance
                          ELSE
                              0
                      END
                  ) balance_201590,
                  SUM(
                      CASE
                          WHEN tbraccd_term_code = '201710' THEN
                              tbraccd_balance
                          ELSE
                              0
                      END
                  ) balance_201710,
                  SUM(
                      CASE
                          WHEN tbraccd_term_code = '201750' THEN
                              tbraccd_balance
                          ELSE
                              0
                      END
                  ) balance_201750,
                  SUM(
                      CASE
                          WHEN tbraccd_term_code = '201790' THEN
                              tbraccd_balance
                          ELSE
                              0
                      END
                  ) balance_201790,
                  SUM(
                      CASE
                          WHEN tbraccd_term_code = '201810' THEN
                              tbraccd_balance
                          ELSE
                              0
                      END
                  ) balance_201810,
                  SUM(
                      CASE
                          WHEN tbraccd_term_code = '201835' THEN
                              tbraccd_balance
                          ELSE
                              0
                      END
                  ) balance_201835,
                  SUM(
                      CASE
                          WHEN tbraccd_term_code = '201850' THEN
                              tbraccd_balance
                          ELSE
                              0
                      END
                  ) balance_201850,
                  SUM(
                      CASE
                          WHEN tbraccd_term_code = '201890' THEN
                              tbraccd_balance
                          ELSE
                              0
                      END
                  ) balance_201890,
                  SUM(
                      CASE
                          WHEN tbraccd_term_code = '201895' THEN
                              tbraccd_balance
                          ELSE
                              0
                      END
                  ) balance_201895,
                  SUM(
                      CASE
                          WHEN tbraccd_term_code = '201910' THEN
                              tbraccd_balance
                          ELSE
                              0
                      END
                  ) balance_201910,
                  SUM(
                      CASE
                          WHEN tbraccd_term_code = '201950' THEN
                              tbraccd_balance
                          ELSE
                              0
                      END
                  ) balance_201950,
                  SUM(
                      CASE
                          WHEN tbraccd_term_code = '201990' THEN
                              tbraccd_balance
                          ELSE
                              0
                      END
                  ) balance_201990,
                  SUM(
                      CASE
                          WHEN tbraccd_term_code = '201995' THEN
                              tbraccd_balance
                          ELSE
                              0
                      END
                  ) balance_201995,
                  SUM(
                      CASE
                          WHEN tbraccd_term_code = '202010' THEN
                              tbraccd_balance
                          ELSE
                              0
                      END
                  ) balance_202010
           FROM tbraccd
           GROUP BY tbraccd_pidm
           HAVING SUM(tbraccd_balance) > 0
       ),
       (
           SELECT sprhold_pidm,
                  MAX(
                      CASE
                          WHEN ranking = 1 THEN
                              sprhold_hldd_code
                          ELSE
                              NULL
                      END
                  ) hold_1,
                  MAX(
                      CASE
                          WHEN ranking = 1 THEN
                              sprhold_reason
                          ELSE
                              NULL
                      END
                  ) sprhold_reason_1,
                  MAX(
                      CASE
                          WHEN ranking = 2 THEN
                              sprhold_hldd_code
                          ELSE
                              NULL
                      END
                  ) hold_2,
                  MAX(
                      CASE
                          WHEN ranking = 2 THEN
                              sprhold_reason
                          ELSE
                              NULL
                      END
                  ) sprhold_reason_2,
                  MAX(
                      CASE
                          WHEN ranking = 3 THEN
                              sprhold_hldd_code
                          ELSE
                              NULL
                      END
                  ) hold_3,
                  MAX(
                      CASE
                          WHEN ranking = 3 THEN
                              sprhold_reason
                          ELSE
                              NULL
                      END
                  ) sprhold_reason_3,
                  MAX(
                      CASE
                          WHEN ranking = 4 THEN
                              sprhold_hldd_code
                          ELSE
                              NULL
                      END
                  ) hold_4,
                  MAX(
                      CASE
                          WHEN ranking = 5 THEN
                              sprhold_hldd_code
                          ELSE
                              NULL
                      END
                  ) hold_5,
                  MAX(
                      CASE
                          WHEN ranking = 6 THEN
                              sprhold_hldd_code
                          ELSE
                              NULL
                      END
                  ) hold_6,
                  MAX(
                      CASE
                          WHEN ranking = 7 THEN
                              sprhold_hldd_code
                          ELSE
                              NULL
                      END
                  ) hold_7,
                  MAX(
                      CASE
                          WHEN ranking = 8 THEN
                              sprhold_hldd_code
                          ELSE
                              NULL
                      END
                  ) hold_8,
                  MAX(
                      CASE
                          WHEN ranking = 9 THEN
                              sprhold_hldd_code
                          ELSE
                              NULL
                      END
                  ) hold_9,
                  MAX(
                      CASE
                          WHEN ranking = 10 THEN
                              sprhold_hldd_code
                          ELSE
                              NULL
                      END
                  ) hold_10
           FROM (
               SELECT sprhold_pidm,
                      stvhldd_desc,
                      sprhold_hldd_code,
                      sprhold_reason,
                      RANK() OVER(
                          PARTITION BY sprhold_pidm
                          ORDER BY sprhold_hldd_code, stvhldd_desc
                      ) AS ranking
               FROM sprhold,
                    stvhldd
               WHERE stvhldd_code = sprhold_hldd_code
                     AND sprhold_to_date >= SYSDATE
                     AND sprhold_from_date <= SYSDATE
           )
           GROUP BY sprhold_pidm
       ),
       (
           SELECT tbbacct_pidm,
                  tbbacct_deli_code,
                  ttvdeli_desc
           FROM tbbacct,
                ttvdeli
           WHERE tbbacct_deli_code = ttvdeli_code
       ),
       (
           SELECT shrlgpa_pidm,
                  shrlgpa_hours_earned hours_earned
           FROM shrlgpa
           WHERE shrlgpa_gpa_type_ind = 'O'
                 AND shrlgpa_levl_code = 'U'
       ) ug,
       (
           SELECT sfrstcr_pidm registered_201950_pidm,
                  SUM(sfrstcr_credit_hr) registered_201950
           FROM sfrstcr
           WHERE sfrstcr_term_code = '201950'
                 AND sfrstcr_rsts_code IN (
               'RE',
               'RW',
               'RI'
           )
           GROUP BY sfrstcr_pidm
       ),
       (
           SELECT sfrstcr_pidm withdrawn_201950_pidm,
                  SUM(sfrstcr_credit_hr) withdrawn_201950
           FROM sfrstcr
           WHERE sfrstcr_term_code = '201950'
                 AND sfrstcr_rsts_code IN (
               'WW',
               'WD',
               'WC',
               'MD'
           )
           GROUP BY sfrstcr_pidm
       ),
       (
           SELECT sfrstcr_pidm total_201950_pidm,
                  SUM(sfrstcr_credit_hr) total_201950
           FROM sfrstcr
           WHERE sfrstcr_term_code = '201950'
                 AND sfrstcr_rsts_code IN (
               'RE',
               'RW',
               'RI',
               'WW',
               'WD',
               'WC',
               'MD'
           )
           GROUP BY sfrstcr_pidm
       ),
       (
           SELECT sfrstcr_pidm registered_201990_pidm,
                  SUM(sfrstcr_credit_hr) registered_201990
           FROM sfrstcr
           WHERE sfrstcr_term_code = '201990'
                 AND sfrstcr_rsts_code IN (
               'RE',
               'RW',
               'RI'
           )
           GROUP BY sfrstcr_pidm
       ),
       (
           SELECT sfrstcr_pidm withdrawn_201990_pidm,
                  SUM(sfrstcr_credit_hr) withdrawn_201990
           FROM sfrstcr
           WHERE sfrstcr_term_code = '201990'
                 AND sfrstcr_rsts_code IN (
               'WW',
               'WD',
               'WC',
               'MD'
           )
           GROUP BY sfrstcr_pidm
       ),
       (
           SELECT sfrstcr_pidm total_201990_pidm,
                  SUM(sfrstcr_credit_hr) total_201990
           FROM sfrstcr
           WHERE sfrstcr_term_code = '201990'
                 AND sfrstcr_rsts_code IN (
               'RE',
               'RW',
               'RI',
               'WW',
               'WD',
               'WC',
               'MD'
           )
           GROUP BY sfrstcr_pidm
       ),
       (
           SELECT sfrstcr_pidm registered_202010_pidm,
                  SUM(sfrstcr_credit_hr) registered_202010
           FROM sfrstcr
           WHERE sfrstcr_term_code = '202010'
                 AND sfrstcr_rsts_code IN (
               'RE',
               'RW',
               'RI'
           )
           GROUP BY sfrstcr_pidm
       ),
       (
           SELECT sfrstcr_pidm withdrawn_202010_pidm,
                  SUM(sfrstcr_credit_hr) withdrawn_202010
           FROM sfrstcr
           WHERE sfrstcr_term_code = '202010'
                 AND sfrstcr_rsts_code IN (
               'WW',
               'WD',
               'WC',
               'MD'
           )
           GROUP BY sfrstcr_pidm
       ),
       (
           SELECT sfrstcr_pidm total_202010_pidm,
                  SUM(sfrstcr_credit_hr) total_202010
           FROM sfrstcr
           WHERE sfrstcr_term_code = '202010'
                 AND sfrstcr_rsts_code IN (
               'RE',
               'RW',
               'RI',
               'WW',
               'WD',
               'WC',
               'MD'
           )
           GROUP BY sfrstcr_pidm
       ),
       (
           SELECT DISTINCT gorvisa_pidm,
                           rtrim(xmlagg(xmlelement(e, gorvisa_vtyp_code || ',')).extract('//text()'), ',') visa_status
           FROM gorvisa
           GROUP BY gorvisa_pidm
       ),
       (
           SELECT DISTINCT goremal_pidm,
                            goremal_email_address njit_email_address
           FROM goremal
           WHERE goremal_emal_code = 'IT'
                 AND goremal_status_ind <> 'I'
                 and GOREMAL_PREFERRED_IND  = 'Y'
                 --and goremal_pidm = 2441788
           GROUP BY goremal_pidm, goremal_email_address
       ) aEmail,
       (
           SELECT DISTINCT goremal_pidm,
                           rtrim(xmlagg(xmlelement(e, goremal_email_address || ',')).extract('//text()'), ',') other_email_address
           FROM goremal 
           WHERE goremal_emal_code = 'P1'
                 AND goremal_status_ind <> 'I'
                 --and goremal_pidm = 2441788
           GROUP BY goremal_pidm
       ) bEmail,
       (
           select  ENTITY_UID,
            rtrim(xmlagg(xmlelement(e, PHONE_NUMBER_COMBINED
                                  || ',')).extract('//text()'), ',') phone_number
            from (
                select distinct ENTITY_UID, PHONE_NUMBER_COMBINED
                from TELEPHONE_CURRENT
            )
            GROUP BY ENTITY_UID
       )
  WHERE tbraccd_pidm = spriden_pidm
        AND tbraccd_pidm = tbbacct_pidm (+)
        AND tbraccd_pidm = sgbstdn_pidm
        AND tbraccd_pidm = sprhold_pidm (+)
        AND tbraccd_pidm = ug.shrlgpa_pidm (+)
        AND sgbstdn_term_code_eff = (
      SELECT MAX(sgbstdn_term_code_eff)
      FROM sgbstdn
      WHERE sgbstdn_pidm = a.sgbstdn_pidm
  )
        AND spriden_change_ind IS NULL
        AND tbraccd_pidm = registered_202010_pidm (+)
        AND tbraccd_pidm = withdrawn_202010_pidm (+)
        AND tbraccd_pidm = total_202010_pidm (+)
        AND tbraccd_pidm = registered_201950_pidm (+)
        AND tbraccd_pidm = withdrawn_201950_pidm (+)
        AND tbraccd_pidm = total_201950_pidm (+)
        AND tbraccd_pidm = registered_201990_pidm (+)
        AND tbraccd_pidm = withdrawn_201990_pidm (+)
        AND tbraccd_pidm = total_201990_pidm (+)
        AND tbraccd_pidm = gorvisa_pidm (+)
        AND tbraccd_pidm = aEmail.goremal_pidm (+)
        AND tbraccd_pidm = bEmail.goremal_pidm (+)
        AND tbraccd_pidm = ENTITY_UID (+)
  ORDER BY 3,
           2