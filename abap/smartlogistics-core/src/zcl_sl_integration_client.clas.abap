CLASS zcl_sl_integration_client DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

    TYPES:
      BEGIN OF ty_result,
        success     TYPE abap_bool,
        status_code TYPE i,
        message     TYPE string,
      END OF ty_result.

    METHODS send_purchase_order
      IMPORTING
        iv_purchase_order_id TYPE string
        iv_supplier          TYPE string
        iv_order_date        TYPE d
        iv_delivery_date     TYPE d
      RETURNING
        VALUE(rs_result)     TYPE ty_result
      RAISING
        cx_http_dest_provider_error
        cx_web_http_client_error.

  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_token_response,
        access_token TYPE string,
        token_type   TYPE string,
        expires_in   TYPE i,
        scope        TYPE string,
      END OF ty_token_response.

ENDCLASS.


CLASS zcl_sl_integration_client IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    TRY.

        DATA(ls_result) =
          send_purchase_order(
            iv_purchase_order_id = 'PO00000005'
            iv_supplier          = 'Green Fields Logistics'
            iv_order_date        = '20261005'
            iv_delivery_date     = '20261009'
          ).

        out->write(
          |Success: { ls_result-success }|
        ).

        out->write(
          |HTTP Status: { ls_result-status_code }|
        ).

        out->write(
          ls_result-message
        ).

      CATCH cx_http_dest_provider_error INTO DATA(lx_destination).
        out->write( lx_destination->get_text( ) ).

      CATCH cx_web_http_client_error INTO DATA(lx_http).
        out->write( lx_http->get_text( ) ).

    ENDTRY.

  ENDMETHOD.


  METHOD send_purchase_order.

    CONSTANTS:
      lc_token_url     TYPE string VALUE
        'https://example.invalid/oauth/token',

      lc_iflow_url     TYPE string VALUE
        'https://example.invalid/http/smartlogistics/purchaseorders',

      lc_client_id     TYPE string VALUE
        'CONFIGURE_VIA_SECURE_COMMUNICATION',

      lc_client_secret TYPE string VALUE
        'CONFIGURE_VIA_SECURE_COMMUNICATION'.


    "------------------------------------------------------------
    " 1. Obtain OAuth2 access token
    "------------------------------------------------------------
    DATA(lo_token_destination) =
      cl_http_destination_provider=>create_by_url(
        i_url = lc_token_url
      ).

    DATA(lo_token_client) =
      cl_web_http_client_manager=>create_by_http_destination(
        i_destination = lo_token_destination
      ).

    DATA(lo_token_request) =
      lo_token_client->get_http_request( ).

    lo_token_request->set_authorization_basic(
      i_username = lc_client_id
      i_password = lc_client_secret
    ).

    lo_token_request->set_header_field(
      i_name  = 'Content-Type'
      i_value = 'application/x-www-form-urlencoded'
    ).

    lo_token_request->set_text(
      'grant_type=client_credentials'
    ).

    DATA(lo_token_response) =
      lo_token_client->execute(
        i_method = if_web_http_client=>post
      ).

    DATA(ls_token_status) =
      lo_token_response->get_status( ).

    DATA(lv_token_response_body) =
      lo_token_response->get_text( ).

    IF ls_token_status-code <> 200.

      lo_token_client->close( ).

      rs_result-success     = abap_false.
      rs_result-status_code = ls_token_status-code.
      rs_result-message     = lv_token_response_body.

      RETURN.

    ENDIF.

    DATA(ls_token) = VALUE ty_token_response( ).

    xco_cp_json=>data->from_string(
      lv_token_response_body
    )->write_to(
      REF #( ls_token )
    ).

    lo_token_client->close( ).


    "------------------------------------------------------------
    " 2. Build Purchase Order JSON
    "------------------------------------------------------------
    DATA(lv_order_date) =
      |{ iv_order_date DATE = ISO }|.

    DATA(lv_delivery_date) =
      |{ iv_delivery_date DATE = ISO }|.

    DATA(lv_purchase_order_json) =
      `{"purchaseOrderId":"` &&
      iv_purchase_order_id &&
      `","supplier":"` &&
      iv_supplier &&
      `","orderDate":"` &&
      lv_order_date &&
      `","deliveryDate":"` &&
      lv_delivery_date &&
      `"}`.


    "------------------------------------------------------------
    " 3. Call Integration Suite
    "------------------------------------------------------------
    DATA(lo_iflow_destination) =
      cl_http_destination_provider=>create_by_url(
        i_url = lc_iflow_url
      ).

    DATA(lo_iflow_client) =
      cl_web_http_client_manager=>create_by_http_destination(
        i_destination = lo_iflow_destination
      ).

    DATA(lo_iflow_request) =
      lo_iflow_client->get_http_request( ).

    lo_iflow_request->set_header_field(
      i_name  = 'Authorization'
      i_value = |Bearer { ls_token-access_token }|
    ).

    lo_iflow_request->set_header_field(
      i_name  = 'Content-Type'
      i_value = 'application/json'
    ).

    lo_iflow_request->set_text(
      lv_purchase_order_json
    ).

    DATA(lo_iflow_response) =
      lo_iflow_client->execute(
        i_method = if_web_http_client=>post
      ).

    DATA(ls_iflow_status) =
      lo_iflow_response->get_status( ).

    DATA(lv_iflow_response_body) =
      lo_iflow_response->get_text( ).

    lo_iflow_client->close( ).


    "------------------------------------------------------------
    " 4. Process Integration Suite response
    "------------------------------------------------------------
    IF ls_iflow_status-code >= 200
       AND ls_iflow_status-code < 300.

      rs_result-success     = abap_true.
      rs_result-status_code = ls_iflow_status-code.
      rs_result-message     = lv_iflow_response_body.

    ELSE.

      DATA(lv_error_message) = ``.

      FIND PCRE '"message"\s*:\s*"([^"]*)"'
        IN lv_iflow_response_body
        SUBMATCHES lv_error_message.

      rs_result-success     = abap_false.
      rs_result-status_code = ls_iflow_status-code.

      IF sy-subrc = 0
         AND lv_error_message IS NOT INITIAL.

        rs_result-message = lv_error_message.

      ELSE.

        rs_result-message = lv_iflow_response_body.

      ENDIF.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
