CLASS lhc_ZCE_UPLOAD DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Upload RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ Upload RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Upload.
    METHODS UploadFile FOR MODIFY
      IMPORTING keys FOR ACTION Upload~UploadFile RESULT result.

ENDCLASS.

CLASS lhc_ZCE_UPLOAD IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD UploadFile.

    TYPES: BEGIN OF ty_excel,
             salesOrder     TYPE string,
             salesOrderItem TYPE string,
             material       TYPE string,
             message        TYPE string,
           END OF ty_excel,
           tt_row TYPE STANDARD TABLE OF ty_excel.

    DATA lt_rows TYPE tt_row.
    DATA lt_content TYPE STANDARD TABLE OF zfilecontent.
    DATA ls_content LIKE LINE OF lt_content.

    DATA: lv_attachment TYPE /dmo/attachment.
    DATA(lv_content) = keys[ 1 ]-%param-fileContentString.

    DATA(lv_file_xstr1) = xco_cp=>string( lv_content )->as_xstring( xco_cp_character=>code_page->utf_8 )->value. "not working
    DATA(lv_file_xstr2) = cl_abap_conv_codepage=>create_out( codepage = `UTF-8` )->convert( lv_content ). "not working
    DATA(lv_file_xstr3) = cl_web_http_utility=>decode_x_base64( lv_content ). "working

    DATA(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_file_xstr3 )->read_access( ).
    DATA(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->at_position( 1 ).

    DATA(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).

    DATA(lo_execute) = lo_worksheet->select( lo_selection_pattern
      )->row_stream(
      )->operation->write_to( REF #( lt_rows ) ).

    lo_execute->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
               )->if_xco_xlsx_ra_operation~execute( ).

    DATA: lt_result TYPE TABLE OF zupload_result_abstract.

    LOOP AT lt_rows INTO DATA(ls_row).
      APPEND INITIAL LINE TO lt_result  ASSIGNING FIELD-SYMBOL(<fs_result>).
      MOVE-CORRESPONDING ls_row TO <fs_result>.
    ENDLOOP.

    result = VALUE #( FOR ls_result IN lt_result
                        ( %cid = keys[ 1 ]-%cid
                          %param = ls_result ) ) .
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZCE_UPLOAD DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZCE_UPLOAD IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    IF 1 = 1.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
