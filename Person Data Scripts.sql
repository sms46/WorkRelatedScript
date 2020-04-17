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