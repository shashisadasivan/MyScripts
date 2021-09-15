###
# Takes a single Table XPO exported from Ax2009 and extracts the Fields 
# Creates XML elements for each field for the basic types
# For Enums, these needs to be extended to include standard or non-standard base enums
# Enums currently only support NoYesId currently
# Once the program runs the elements are copied to the clipboard
# Paste the string into the D365 F&O's Table xml file
###


import pyperclip #To copy the XML generated string to the clipboard

file = open("Table_TutorialDefData.xpo")
lines = file.readlines()

def getNameAfterHash(line, nameToCheck = ''):
    if len(nameToCheck) > 0 and nameToCheck not in line:
        return ''

    index = line.find("#")
    #print(line[index+1:])
    return line[index+1:]

def fieldExtract(lineFrom):
    
    xmlFieldStr = """<AxTableField xmlns="" i:type="{fieldType}">
    <Name>{fieldName}</Name>
    <Label>{fieldLabel}</Label>
</AxTableField>"""
    
    fieldType = getNameAfterHash(lines[lineFrom + 1].strip())
    fieldName = getNameAfterHash(lines[lineFrom + 3].strip())
    fieldLabel = getNameAfterHash(lines[lineFrom + 4].strip(), 'Label')
    fieldEnumType = ""

    if fieldType == "REAL":
        fieldType = "AxTableFieldReal"
    elif fieldType == "STRING":
        fieldType = "AxTableFieldString"
    elif fieldType == "INT":
        fieldType = "AxTableFieldInt"
    elif fieldType == "ENUM":
        fieldType = "AxTableFieldEnum"
        fieldEnumType = getNameAfterHash(lines[lineFrom + 6].strip())
        if fieldEnumType == "NoYesCombo" or fieldEnumType == "NoYes":
            fieldEnumType = "NoYesId"
            xmlFieldStr = """<AxTableField xmlns="" i:type="{fieldType}">
    <Name>{fieldName}</Name>
    <ExtendedDataType>NoYesId</ExtendedDataType>
    <Label>{fieldLabel}</Label>
    <EnumType>NoYes</EnumType>
</AxTableField>"""
        else:
            xmlFieldStr = """<AxTableField xmlns="" i:type="{fieldType}">
    <Name>{fieldName}</Name>
    <Label>{fieldLabel}</Label>
    <ExtendedDataType>{fieldEnumType}</ExtendedDataType>
</AxTableField>"""

    # OPtional - To remove field prefix (can be used to replace them as well)
    if fieldName.startswith("IP_"):
        fieldName = fieldName[3:]
        fieldName = fieldName[0].upper() + fieldName[1:]
    
    if fieldLabel.startswith("IP_"):
        fieldLabel = fieldLabel[3:]
        fieldLabel = fieldLabel[0].upper() + fieldLabel[1:]

    retXml = xmlFieldStr.format(fieldType=fieldType, fieldName=fieldName, fieldLabel=fieldLabel, fieldEnumType=fieldEnumType)
    return retXml;

fieldXmls = ""
for lineNum in range(len(lines)):
    if "FIELD #" in lines[lineNum]:
        #print(lines[lineNum])
        fieldXML = fieldExtract(lineNum)
        fieldXmls += fieldXML + "\n"

#print(fieldXmls)
# Copy the xml string to the clipboard
pyperclip.copy(fieldXmls)