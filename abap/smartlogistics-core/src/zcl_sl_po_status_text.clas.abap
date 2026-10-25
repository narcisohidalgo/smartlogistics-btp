CLASS zcl_sl_po_status_text DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_sadl_exit.
    INTERFACES if_sadl_exit_calc_element_read.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_sl_po_status_text IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    LOOP AT it_requested_calc_elements
      ASSIGNING FIELD-SYMBOL(<requested_element>).

      CASE <requested_element>.

        WHEN 'STATUSTEXT'.

          INSERT CONV string( 'STATUS' )
            INTO TABLE et_requested_orig_elements.


        WHEN 'LOGISTICSSTATUSTEXT'.

          INSERT CONV string( 'LOGISTICSSTATUS' )
            INTO TABLE et_requested_orig_elements.

      ENDCASE.

    ENDLOOP.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA calculated_data
      TYPE STANDARD TABLE OF zc_sl_purchaseorder
      WITH DEFAULT KEY.

    calculated_data =
      CORRESPONDING #( it_original_data ).

    LOOP AT calculated_data
      ASSIGNING FIELD-SYMBOL(<order>).

      "----------------------------------------------------------
      " Purchase Order Status
      "----------------------------------------------------------
      CASE <order>-Status.

        WHEN 'NW'.
          <order>-StatusText = 'New'.

        WHEN OTHERS.
          <order>-StatusText = <order>-Status.

      ENDCASE.


      "----------------------------------------------------------
      " Logistics Integration Status
      "----------------------------------------------------------
      CASE <order>-LogisticsStatus.

        WHEN 'NEW'.
          <order>-LogisticsStatusText = 'Not Sent'.

        WHEN 'SENT'.
          <order>-LogisticsStatusText = 'Sent'.

        WHEN OTHERS.
          <order>-LogisticsStatusText =
            <order>-LogisticsStatus.

      ENDCASE.

    ENDLOOP.

    ct_calculated_data =
      CORRESPONDING #( calculated_data ).

  ENDMETHOD.


ENDCLASS.
