-- dejan (sp) sarka has great chapter in book

DECLARE @x xml
SET @x = '<ROOT><a>111</a></ROOT>'
SELECT @x.query('/ROOT/a')

DECLARE @myDoc xml
DECLARE @ProdID int
SET @myDoc = '<Root>
<ProductDescription ProductID="1" ProductName="Road Bike">
<Features>
  <Warranty>1 year parts and labor</Warranty>
  <Maintenance>3 year parts and labor extended maintenance is available</Maintenance>
</Features>
</ProductDescription>
<ProductDescription ProductID="5" ProductName="dirt Bike">
<Features>
  <Warranty>1 year parts and labor</Warranty>
  <Maintenance>3 year parts and labor extended maintenance is available</Maintenance>
</Features>
</ProductDescription>
</Root>'

SET @ProdID =  @myDoc.value('(/Root/ProductDescription/@ProductID1]', 'int' )
SELECT @ProdID
