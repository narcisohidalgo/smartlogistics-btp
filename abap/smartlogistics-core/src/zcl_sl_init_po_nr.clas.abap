CLASS zcl_sl_init_po_nr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_sl_init_po_nr IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA:
      lv_object   TYPE cl_numberrange_objects=>nr_attributes-object,
      lt_interval TYPE cl_numberrange_intervals=>nr_interval,
      ls_interval TYPE cl_numberrange_intervals=>nr_nriv_line.

    lv_object = 'ZSL_PO_NR'.

    ls_interval-nrrangenr  = '01'.
    ls_interval-fromnumber = '00000001'.
    ls_interval-tonumber   = '99999999'.
    ls_interval-nrlevel    = '00000005'.
    ls_interval-externind  = space.
    ls_interval-procind    = 'U'.

    APPEND ls_interval TO lt_interval.

    TRY.

        cl_numberrange_intervals=>update(
          EXPORTING
            interval  = lt_interval
            object    = lv_object
            subobject = space
          IMPORTING
            error     = DATA(lv_error)
            error_inf = DATA(ls_error)
            error_iv  = DATA(lt_error_iv)
            warning   = DATA(lv_warning)
        ).

        IF lv_error = abap_true.
          out->write( 'Error updating number range interval.' ).
        ELSE.
          out->write( 'PO number range level set to 00000005.' ).
        ENDIF.

      CATCH cx_root INTO DATA(lx_error).
        out->write( lx_error->get_text( ) ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
