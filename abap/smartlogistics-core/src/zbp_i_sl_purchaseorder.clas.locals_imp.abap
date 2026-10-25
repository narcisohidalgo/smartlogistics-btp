CLASS lhc_purchaseorderitem DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calculateNetAmount FOR DETERMINE ON MODIFY
       keys FOR PurchaseOrderItem~calculateNetAmount.
    METHODS updateTotalAmount FOR DETERMINE ON MODIFY
       keys FOR PurchaseOrderItem~updateTotalAmount.
    METHODS validateProduct FOR VALIDATE ON SAVE
       keys FOR PurchaseOrderItem~validateProduct.

    METHODS validateQuantity FOR VALIDATE ON SAVE
       keys FOR PurchaseOrderItem~validateQuantity.

    METHODS validateUnitPrice FOR VALIDATE ON SAVE
       keys FOR PurchaseOrderItem~validateUnitPrice.
    METHODS setItemNumber FOR DETERMINE ON MODIFY
       keys FOR PurchaseOrderItem~setItemNumber.

ENDCLASS.

CLASS lhc_purchaseorderitem IMPLEMENTATION.

  METHOD calculateNetAmount.

    READ ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
      ENTITY PurchaseOrderItem
        FIELDS ( Quantity UnitPrice )
        WITH CORRESPONDING #( keys )
      RESULT DATA(items).

    MODIFY ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
      ENTITY PurchaseOrderItem
        UPDATE FIELDS ( NetAmount )
        WITH VALUE #(
          FOR item IN items
          (
            %tky      = item-%tky
            NetAmount = item-Quantity * item-UnitPrice
          )
        ).

  ENDMETHOD.

  METHOD updateTotalAmount.

    READ ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
      ENTITY PurchaseOrderItem BY \_PurchaseOrder
        FIELDS ( PurchaseOrderUuid )
        WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    MODIFY ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
      ENTITY PurchaseOrder
        EXECUTE recalculateTotalAmount
        FROM CORRESPONDING #( orders ).

  ENDMETHOD.

  METHOD validateProduct.

    READ ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
      ENTITY PurchaseOrderItem
        FIELDS ( ProductUuid )
        WITH CORRESPONDING #( keys )
      RESULT DATA(items).

    LOOP AT items INTO DATA(item).

      IF item-ProductUuid IS INITIAL.

        APPEND VALUE #(
          %tky = item-%tky
        ) TO failed-PurchaseOrderItem.

        APPEND VALUE #(
          %tky = item-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Product is required'
          )
          %element-ProductUuid = if_abap_behv=>mk-on
        ) TO reported-PurchaseOrderItem.

        CONTINUE.

      ENDIF.

      SELECT SINGLE
        FROM zsl_product
        FIELDS product_uuid
        WHERE product_uuid = @item-ProductUuid
        INTO @DATA(product_uuid).

      IF sy-subrc <> 0.

        APPEND VALUE #(
          %tky = item-%tky
        ) TO failed-PurchaseOrderItem.

        APPEND VALUE #(
          %tky = item-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Product does not exist'
          )
          %element-ProductUuid = if_abap_behv=>mk-on
        ) TO reported-PurchaseOrderItem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateQuantity.

    READ ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
      ENTITY PurchaseOrderItem
        FIELDS ( Quantity )
        WITH CORRESPONDING #( keys )
      RESULT DATA(items).

    LOOP AT items INTO DATA(item).

      IF item-Quantity IS INITIAL
         OR item-Quantity <= 0.

        APPEND VALUE #(
          %tky = item-%tky
        ) TO failed-PurchaseOrderItem.

        APPEND VALUE #(
          %tky = item-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Quantity must be greater than zero'
          )
          %element-Quantity = if_abap_behv=>mk-on
        ) TO reported-PurchaseOrderItem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateUnitPrice.

    READ ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
      ENTITY PurchaseOrderItem
        FIELDS ( UnitPrice )
        WITH CORRESPONDING #( keys )
      RESULT DATA(items).

    LOOP AT items INTO DATA(item).

      IF item-UnitPrice < 0.

        APPEND VALUE #(
          %tky = item-%tky
        ) TO failed-PurchaseOrderItem.

        APPEND VALUE #(
          %tky = item-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Unit price cannot be negative'
          )
          %element-UnitPrice = if_abap_behv=>mk-on
        ) TO reported-PurchaseOrderItem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD setItemNumber.

    READ ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
      ENTITY PurchaseOrderItem
        FIELDS ( PurchaseOrderUuid ItemNumber )
        WITH CORRESPONDING #( keys )
      RESULT DATA(created_items).

    READ ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
      ENTITY PurchaseOrderItem BY \_PurchaseOrder
        FIELDS ( PurchaseOrderUuid )
        WITH CORRESPONDING #( keys )
      RESULT DATA(parent_orders).

    READ ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
      ENTITY PurchaseOrder
        BY \_Items
        FIELDS ( PurchaseOrderUuid ItemNumber )
        WITH CORRESPONDING #( parent_orders )
      RESULT DATA(all_items).

    LOOP AT created_items INTO DATA(created_item).

      DATA(max_item_number) = 0.

      LOOP AT all_items INTO DATA(existing_item)
        WHERE PurchaseOrderUuid = created_item-PurchaseOrderUuid
          AND ItemUuid <> created_item-ItemUuid.

        DATA(item_number_int) = CONV i( existing_item-ItemNumber ).

        IF item_number_int > max_item_number.
          max_item_number = item_number_int.
        ENDIF.

      ENDLOOP.

      DATA(next_item_number) = max_item_number + 10.
      DATA next_item_number_numc TYPE n LENGTH 5.

      next_item_number_numc = next_item_number.

      MODIFY ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
        ENTITY PurchaseOrderItem
          UPDATE FIELDS ( ItemNumber )
          WITH VALUE #(
            (
              %tky       = created_item-%tky
              ItemNumber = next_item_number_numc
            )
          ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_PurchaseOrder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR PurchaseOrder RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR PurchaseOrder RESULT result.
    METHODS setInitialStatus FOR DETERMINE ON MODIFY
       keys FOR PurchaseOrder~setInitialStatus.
    METHODS recalculateTotalAmount FOR MODIFY
       keys FOR ACTION PurchaseOrder~recalculateTotalAmount.
    METHODS validateDates FOR VALIDATE ON SAVE
       keys FOR PurchaseOrder~validateDates.

    METHODS validateSupplier FOR VALIDATE ON SAVE
       keys FOR PurchaseOrder~validateSupplier.
    METHODS setPurchaseOrderId FOR DETERMINE ON MODIFY
       keys FOR PurchaseOrder~setPurchaseOrderId.
    METHODS sendToLogistics FOR MODIFY
      IMPORTING keys FOR ACTION PurchaseOrder~sendToLogistics.
    METHODS get_instance_features FOR INSTANCE FEATURES
      keys REQUEST requested_features FOR PurchaseOrder RESULT result.

ENDCLASS.

CLASS lhc_PurchaseOrder IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD setInitialStatus.

    MODIFY ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
      ENTITY PurchaseOrder
        UPDATE FIELDS (
          Status
          LogisticsStatus
        )
        WITH VALUE #(
          FOR key IN keys
          (
            %tky            = key-%tky
            Status          = 'NW'
            LogisticsStatus = 'NEW'
          )
        ).

  ENDMETHOD.

  METHOD recalculateTotalAmount.

    READ ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
      ENTITY PurchaseOrder
        BY \_Items
        FIELDS ( NetAmount )
        WITH CORRESPONDING #( keys )
      RESULT DATA(items).

    LOOP AT keys INTO DATA(key).

      DATA(total_amount) = CONV zsl_po-total_amount( 0 ).

      LOOP AT items INTO DATA(item)
        WHERE PurchaseOrderUuid = key-PurchaseOrderUuid.

        total_amount += item-NetAmount.

      ENDLOOP.

      MODIFY ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
        ENTITY PurchaseOrder
          UPDATE FIELDS ( TotalAmount )
          WITH VALUE #(
            (
              %tky        = key-%tky
              TotalAmount = total_amount
            )
          ).

    ENDLOOP.

  ENDMETHOD.

  METHOD validateDates.

    READ ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
      ENTITY PurchaseOrder
        FIELDS ( OrderDate DeliveryDate )
        WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    LOOP AT orders INTO DATA(order).

      IF order-OrderDate IS INITIAL
         OR order-DeliveryDate IS INITIAL.

        APPEND VALUE #(
          %tky = order-%tky
        ) TO failed-PurchaseOrder.

        APPEND VALUE #(
          %tky = order-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Order date and delivery date are required'
          )
        ) TO reported-PurchaseOrder.

        CONTINUE.

      ENDIF.

      IF order-DeliveryDate < order-OrderDate.

        APPEND VALUE #(
          %tky = order-%tky
        ) TO failed-PurchaseOrder.

        APPEND VALUE #(
          %tky = order-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Delivery date cannot be before order date'
          )
          %element-DeliveryDate = if_abap_behv=>mk-on
        ) TO reported-PurchaseOrder.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateSupplier.

    READ ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
      ENTITY PurchaseOrder
        FIELDS ( SupplierUuid )
        WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    LOOP AT orders INTO DATA(order).

      " Supplier is mandatory
      IF order-SupplierUuid IS INITIAL.

        APPEND VALUE #(
          %tky = order-%tky
        ) TO failed-PurchaseOrder.

        APPEND VALUE #(
          %tky = order-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Supplier is required'
          )
          %element-SupplierUuid = if_abap_behv=>mk-on
        ) TO reported-PurchaseOrder.

        CONTINUE.

      ENDIF.

      " Supplier must exist
      SELECT SINGLE
        FROM zsl_supplier
        FIELDS supplier_uuid
        WHERE supplier_uuid = @order-SupplierUuid
        INTO @DATA(supplier_uuid).

      IF sy-subrc <> 0.

        APPEND VALUE #(
          %tky = order-%tky
        ) TO failed-PurchaseOrder.

        APPEND VALUE #(
          %tky = order-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Supplier does not exist'
          )
          %element-SupplierUuid = if_abap_behv=>mk-on
        ) TO reported-PurchaseOrder.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD setPurchaseOrderId.

    READ ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
      ENTITY PurchaseOrder
      FIELDS ( PurchaseOrderId )
      WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    LOOP AT orders INTO DATA(order).

      " Do not assign a new number if the PO already has one
      IF order-PurchaseOrderId IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      TRY.

          cl_numberrange_runtime=>number_get(
            EXPORTING
              nr_range_nr = '01'
              object      = 'ZSL_PO_NR'
            IMPORTING
              number      = DATA(lv_number)
              returncode  = DATA(lv_returncode)
          ).

          " NUMBER_GET returns a wider number representation.
          " Convert it first to an integer and then to NUMC(8).
          DATA lv_po_number TYPE n LENGTH 8.

          lv_po_number = CONV i( lv_number ).

          MODIFY ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
            ENTITY PurchaseOrder
              UPDATE FIELDS ( PurchaseOrderId )
              WITH VALUE #(
                (
                  %tky            = order-%tky
                  PurchaseOrderId = |PO{ lv_po_number }|
                )
              ).

        CATCH cx_number_ranges INTO DATA(lx_number_range).

          APPEND VALUE #(
            %tky = order-%tky
            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-error
              text     = lx_number_range->get_text( )
            )
          ) TO reported-PurchaseOrder.

      ENDTRY.

    ENDLOOP.

  ENDMETHOD.

  METHOD sendToLogistics.

    READ ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
      ENTITY PurchaseOrder
      FIELDS (
        PurchaseOrderId
        SupplierUuid
        OrderDate
        DeliveryDate
      )
      WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    LOOP AT orders INTO DATA(order).

      SELECT SINGLE name
        FROM zsl_supplier
        WHERE supplier_uuid = @order-SupplierUuid
        INTO @DATA(supplier_name).

      TRY.

          DATA(integration_client) =
            NEW zcl_sl_integration_client( ).

          DATA(integration_result) =
            integration_client->send_purchase_order(
              iv_purchase_order_id = CONV string( order-PurchaseOrderId )
              iv_supplier          = CONV string( supplier_name )
              iv_order_date        = order-OrderDate
              iv_delivery_date     = order-DeliveryDate
            ).

          IF integration_result-success = abap_false.

            APPEND VALUE #(
              %tky = order-%tky
            ) TO failed-PurchaseOrder.

            APPEND VALUE #(
              %tky = order-%tky
              %msg = new_message_with_text(
                severity = if_abap_behv_message=>severity-error
                text     = integration_result-message
              )
            ) TO reported-PurchaseOrder.

          ELSE.

            " Mark Purchase Order as sent to logistics
            MODIFY ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
              ENTITY PurchaseOrder
                UPDATE FIELDS ( LogisticsStatus )
                WITH VALUE #(
                  (
                    %tky            = order-%tky
                    LogisticsStatus = 'SENT'
                  )
                ).

            APPEND VALUE #(
              %tky = order-%tky
              %msg = new_message_with_text(
                severity = if_abap_behv_message=>severity-success
                text     = |Purchase order { order-PurchaseOrderId } sent to logistics successfully|
              )
            ) TO reported-PurchaseOrder.

          ENDIF.

        CATCH cx_http_dest_provider_error INTO DATA(destination_error).

          APPEND VALUE #(
            %tky = order-%tky
          ) TO failed-PurchaseOrder.

          APPEND VALUE #(
            %tky = order-%tky
            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-error
              text     = destination_error->get_text( )
            )
          ) TO reported-PurchaseOrder.

        CATCH cx_web_http_client_error INTO DATA(http_error).

          APPEND VALUE #(
            %tky = order-%tky
          ) TO failed-PurchaseOrder.

          APPEND VALUE #(
            %tky = order-%tky
            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-error
              text     = http_error->get_text( )
            )
          ) TO reported-PurchaseOrder.

      ENDTRY.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zi_sl_purchaseorder IN LOCAL MODE
      ENTITY PurchaseOrder
      FIELDS ( LogisticsStatus )
      WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    result = VALUE #(
      FOR order IN orders
      (
        %tky = order-%tky

        %action-sendToLogistics =
          COND #(
            WHEN order-LogisticsStatus = 'SENT'
            THEN if_abap_behv=>fc-o-disabled
            ELSE if_abap_behv=>fc-o-enabled
          )
      )
    ).

  ENDMETHOD.

ENDCLASS.
