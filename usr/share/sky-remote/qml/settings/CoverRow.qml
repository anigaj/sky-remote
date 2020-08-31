import QtQuick 2.0
import Sailfish.Silica 1.0

Item 
{
    id: coverRow
   
    property int rowId
    property alias source1: cmbBox1.iconSource
    property alias source2: cmbBox2.iconSource  
    height: bMenu.buttonHeight

    ButtonMenu
    {        
        id: bMenu
        property int buttonNum
        onActivated:{
           var currentButtons = coverButtons.value

            currentButtons[rowId]["keypress" + buttonNum] =_activeMenuItem.keyPress
            currentButtons[rowId]["imgdark" + buttonNum] =_activeMenuItem.iconSrcDark
            currentButtons[rowId]["imglight" + buttonNum] =_activeMenuItem.iconSrcLight
            coverButtons.value = currentButtons
            coverButtonList.opacity = 1.0
            content.opacity = 1.0
        }
    } 
   Row
    {
        width:parent.width
        height: parent.height
        Label 
        {
            id: rowNum      
            font.pixelSize: Theme.fontSizeLarge
            //% "Row"
           text: qsTrId("sky-row") + " " +  rowId
            width: parent.width/4
            height: parent.height 
            verticalAlignment:Text.AlignVCenter
        }
        BackgroundItem 
        {
            id: cmbBox1      
            width: parent.width/4 
            property string iconSource
            height: parent.height    
            Image
            {
                source: cmbBox1.iconSource 
                fillMode: Image.PreserveAspectFit  
                height: parent.height 
            }
            onClicked:
            {
                coverButtonList.opacity = 0.1
                content.opacity = 0.1
                bMenu.buttonNum = 1
                bMenu.open(page)        
            }  
        }
        BackgroundItem 
        {
            id: cmbBox2
            width: parent.width/4
            property string iconSource  
            height: parent.height       
            Image
            {
                source: cmbBox2.iconSource  
                fillMode: Image.PreserveAspectFit             
                height: parent.height  
            }
            onClicked:
            {
                coverButtonList.opacity = 0.1
                content.opacity = 0.1
                bMenu.buttonNum = 2
                bMenu.open(page)       
            }           
        }
        Image
        {
            id: actionIcon 
            source: "image://theme/icon-m-clear"
            width: parent.width/4  
            fillMode: Image.PreserveAspectFit
            MouseArea 
            {
                height: parent.height
                width: parent.width
                //% "Removing user"
                onClicked: remorse.execute(coverRow, qsTrId("removing-user"), function() {       
                    skySettings.coverRows =skySettings.coverRows - 1
                    var configList = coverButtons.value
                    configList.splice(rowId,1)
                    coverButtons.value = configList 
                })
            }
        }
    }

    RemorseItem
    {
        id: remorse
    }
}

