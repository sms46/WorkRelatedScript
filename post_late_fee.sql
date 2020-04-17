 /*
rem    Program:         ABV_TSAAREV_Update.sql
rem    Author:          AIS
rem    Date:            04-OCT-2019
rem
rem    Description:  This is written to post specified charge to students in a popsel
rem                   NOTE: amount defined as a param that will be the same for each posting
rem
rem                  
rem    Usage: There are three parameters, 
rem           param1 = term code format: 201310
rem           param2 = Detail Code to post
rem           param3 = amount to post
rem           param4 = popsel application
rem           param5 = popsel selection id
rem           param6 = popsel creator id
rem           param7 = popsel user id

todo:
  update spool directory/file name
  update header documentation
  
*/

set serveroutput on;
set verify off;
set termout on;
set echo off;
set pause off;
set pagesize 55;
  -------------------------------------------------------------------------------------------------
  --------------------------EPRINT DECLARATION-----------------------------------------------------
  -------------------------------------------------------------------------------------------------
 
set verify off;
set echo off;
set serveroutput on 

 

--------------------------------------------------------------------------------
--  Define Parameters
--------------------------------------------------------------------------------

DEFINE term_code   = &param1;
DEFINE detail_code = &param2;
DEFINE amount      = &param3;
DEFINE application = &param4;
DEFINE selection   = &param5;
DEFINE creator_id  = &param6;
DEFINE user_id     = &param7;


--
  -------------------------------------------------------------------------------------------------
  --------------------------MAIN SCRIPT COMPONENT----------------------------------------------
  -------------------------------------------------------------------------------------------------

declare
  -------------------------------------------------------------------------------------------------
  --------------------------variable declaration---------------------------------------------------
  -------------------------------------------------------------------------------------------------
  err_num                  varchar2 (10);            --displays error number
  err_msg                  varchar2 (2000) := null;  --displays error message
  err_msg2                 varchar2 (2000) := null;  --displays error message

  v_log_handle utl_file.file_type;
 
  v_application            glbextr.glbextr_application%type := null;
  v_selection              glbextr.glbextr_selection%type   := null;
  v_creator_id             glbextr.glbextr_creator_id%type  := null;
  v_user_id                glbextr.glbextr_user_id%type     := null;

  -- api call variables
  v_pidm                   number (20);
  v_term_code              varchar2 (2000);
  v_detail_code            varchar2 (2000);
  v_amount                 number (20, 2);
  v_entry_date             date;
  v_effective_date         date;
  v_trans_date             date;
  v_statement_date         date;
  v_srce_code              varchar2 (2000);
  v_session_number         number (20);
  v_data_origin            varchar2 (2000);
  v_acct_feed_ind          varchar2 (2000);
  v_user                   varchar2 (2000);
  v_tran_number_out        number (20);
  v_rowid_out              varchar2 (2000);

  -------------------------------------------------------------------------------------------------
  --------------------CURSOR DECLARATION-----------------------------------------------------------
  -------------------------------------------------------------------------------------------------

  -- Data Fetch from popsel for processing cursor

  cursor pool_cursor is
    select glbextr_key pidm,
    spriden_id
    from   glbextr, spriden
    where   glbextr_application = v_application and 
           glbextr_selection   = v_selection and
           glbextr_creator_id  = v_creator_id and
           glbextr_user_id     = v_user_id and
           glbextr_key= spriden_pidm and
           spriden_change_ind is null;
    

-------------------MAIN ROUTINE - ACTUAL CODE EXECUTION POINT--------------------------------------
begin

  ------------------------------------
  --
  dbms_output.enable( 500000 );
  --
  ------------------------------------
 v_log_handle  := utl_file.fopen ('STUDENT_BURSAR_LOG', 'Post_late_fees_log_'|| to_char (sysdate, 'Dy DD-MON-YYYY HH24MISS')  ||'.csv' , 'w');
  
  utl_file.put_line(v_log_handle,'Starting main procedure-----------------------------------');
  utl_file.put_line(v_log_handle,     'RUNDATE: ' || to_char (sysdate, 'Dy DD-MON-YYYY HH24:MI:SS'));
  
  
  
  --set popsel varaibles
  v_application := '&&application';
  v_selection   := '&&selection';
  v_creator_id  := '&&creator_id';
  v_user_id     := '&&user_id';
  
  
  --set api call variables
  v_term_code      := '&&term_code';
  v_detail_code    := '&&detail_code';
  v_amount         := '&&amount';
  
  v_entry_date     := sysdate;
  v_effective_date := sysdate;
  v_trans_date     := sysdate;
  v_srce_code      := 'T';
  v_session_number := '0';
  v_acct_feed_ind  := 'Y';
  v_user           := 'BANWORX';
   
   
 
  for cur_var in pool_cursor
    loop
      begin
        v_pidm := cur_var.pidm;
        
         tb_receivable.p_create(
           p_pidm                   => v_pidm,    
           p_term_code              => v_term_code,   
           p_detail_code            => v_detail_code, 
           p_amount                 => v_amount, 
           p_entry_date             => v_entry_date,
           p_effective_date         => v_effective_date,
           p_trans_date             => v_trans_date,
           p_srce_code              => v_srce_code,
           p_session_number         => v_session_number,
           p_data_origin            => v_data_origin,
           p_acct_feed_ind          => v_acct_feed_ind,
           p_user                   => v_user,
           p_tran_number_out        => v_tran_number_out,
           p_rowid_out              => v_rowid_out );
           utl_file.put_line(v_log_handle, 'Successfully Inserted:,ID=' || cur_var.spriden_id|| ',Detail code=' || v_detail_code|| ',amount='|| v_amount  );
      exception
        when others then
          rollback;
          err_num := sqlcode;
          err_msg2 := substr (sqlerrm, 1, 100);
          utl_file.put_line(v_log_handle, 'ORACLE ERROR: update record - ORA: ' || err_num || ' MESSAGE: ' || err_msg2 );
      
      end;
    end loop;
       
        
  -- COMMIT all the changes
  commit;
  utl_file.fclose (v_log_handle);
    
exception
   when no_data_found then
      utl_file.put_line(v_log_handle,'No Data Found');
      raise;
	  utl_file.fclose (v_log_handle);
   when others then
   
     rollback;
     err_num := sqlcode;
     err_msg2 := substr( sqlerrm, 1, 100 );
     utl_file.put_line(v_log_handle, 'ORACLE ERROR: update record - ORA: ' || err_num || ' MESSAGE: ' || err_msg2 );
	 utl_file.fclose (v_log_handle);
end;
/

spool off
exit;