import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4
import org.nemomobile.configuration 1.0

Page 
{
    id: page
             
    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height
        
        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium
            
            PageHeader
            {
                //% "Sky Q box details"
                title: qsTrId("sky-details")
            }
            
            Label
            {
                id: skyDetails
                anchors 
                {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.paddingLarge
                }
                font.pixelSize: Theme.fontSizeMedium
                 //% "Getting  details"
                 text:qsTrId("sky-getting") + " ..."             
            }
        }
    }
        
    Component.onCompleted:
    {
        python.call('helper.getDetails',[],function(result) {     
            skyDetails.text = result
        })
    }  
}
