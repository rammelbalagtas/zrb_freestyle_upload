@EndUserText.label: 'Result structure'
define abstract entity zupload_result_abstract
{
    salesOrder : abap.char(10);
    salesOrderItem : abap.char(5);
    material : abap.char(18);
    message : abap.string(0);
}
