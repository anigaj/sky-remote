import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4
import org.nemomobile.configuration 1.0

Page 
{
    id: page
    property double timeOut:2.0        
    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height
        PullDownMenu
        {         
            MenuItem
            {
                id: details 
                //% "Sky Q box details" 
                text: qsTrId("sky-details")
                onClicked: pageStack.push(Qt.resolvedUrl("SkyDetails.qml"))
            }
            MenuItem
            {
                id: settings 
                //% "Settings" 
                text: qsTrId("sky-settings")
                onClicked: pageStack.push(Qt.resolvedUrl("../settings/MainSettingsPage.qml"))
            }
        }
        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingLarge*5
            
            PageHeader
            {
                //% "Connect to Sky Q Box"
                title: qsTrId("sky-connect-box")
            }
            Label
            {
                id: searchBox
                visible: true
                anchors 
                {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.paddingLarge
                }
                font.pixelSize: Theme.fontSizeExtraLarge
                 //% "Searching for Sky Q Box"
                 text:qsTrId("sky-searching") + " ..."             
            }
            
            Label
            {
                id: notFound
                visible: false
                anchors 
                {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.paddingLarge
                }
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeLarge
                color:  Theme.primaryColor
                 //% "Sky Q box not detected retry or enter ip address manually"
                 text:qsTrId("sky-not-found")       
            }
    
            Button 
            { 
                id: retry
                visible: false
                //% "Retry"
                text: qsTrId("sky-retry")
                width: parent.width - 2*Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter                 
                onClicked: 
                {
                    searchBox.visible = true
                    notFound.visible = false
                    retry.visible = false
                    ipEntry.visible = false
                    notFoundExplain.visible = false
                    python.call('helper.findSkyBox',[timeOut],function(result) {
                        if (result) pageStack.replace(Qt.resolvedUrl("RemoteControl.qml"))        
                        else     
                        {    
                             searchBox.visible = false         
                            notFound.visible = true       
                            retry.visible = true
                            ipEntry.visible = true
                            notFoundExplain.visible = true
                            
                timeOut = Math.min(timeOut + 2,10)       
                        } 
                    })
                }
            }
            
            TextField
            {
                id: ipEntry
                visible: false
                anchors.horizontalCenter: parent.horizontalCenter               
                width: parent.width - 2*Theme.paddingLarge 
                placeholderText: label
                //% "IP Address"
                label:qsTrId("sky-ip")
                inputMethodHints:Qt.ImhDigitsOnly
                color:  Theme.primaryColor
                font.pixelSize: Theme.fontSizeLarge            
                    EnterKey.onClicked: {
                       // python.call('helper.setSkyBoxIP',[text],function() { console.log("completed")})
                        focus = false
                    }
                    onActiveFocusChanged: {
                    if (!activeFocus)                
                    {
                        searchBox.visible = true
                        notFound.visible = false
                        retry.visible = false
                        ipEntry.visible = false
                        notFoundExplain.visible = false
                        python.call('helper.setSkyBoxIP',[text],function(result) {                          
                            if (result) pageStack.replace(Qt.resolvedUrl("RemoteControl.qml"))          
                            else
                            {
                                searchBox.visible = false
                                notFound.visible = true
                                retry.visible = true
                                ipEntry.visible = true
                                notFoundExplain.visible = true
                                timeOut = timeOut + 2         
                            } 
                        })
                    }
                }
            }
            
            Label
            {
                id: notFoundExplain
                visible: false
                anchors 
                {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.paddingLarge
                }
                wrapMode: Text.Wrap
                opacity: 0.6
                font.pixelSize: Theme.fontSizeSmall
                color:  Theme.highlightColor
                 //% "Check the Sky Q box is powered and the phone is connected to the same wifi network as the box. The sky q box ip address can be found by going to Home->Settings->System on the sky q box."
                 text:qsTrId("sky-not-found-detail")       
            }
        }
    }
    Component.onCompleted:
    {
        python.call('helper.findSkyBox',[timeOut],function(result) {     
            if (result) pageStack.replace(Qt.resolvedUrl("RemoteControl.qml")) 
            else
            {
                searchBox.visible = false
                notFound.visible = true
                retry.visible = true
                ipEntry.visible = true
                notFoundExplain.visible = true
                timeOut = timeOut + 2         
            }
        })
    } 
}
