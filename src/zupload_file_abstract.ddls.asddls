@EndUserText.label: 'Upload file'
define abstract entity zupload_file_abstract
{
    mimeType : abap.string(0);
    fileName: abap.string(0);
    fileContentString: abap.string(0);
    fileContent: abap.rawstring(0); 
}
