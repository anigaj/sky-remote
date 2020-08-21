import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    id: remoteButton

    property string text
    property bool highlighted: down
    property string gridId  

    function getSource(id)
    {             
        switch(id) {            
            case "1":{
                text = "up"
                return "image://theme/icon-m-up"
            }
            case "3":{
                text="left"
                return "image://theme/icon-m-left"
            }
            case "4":{
                text="select"
                return "image://theme/icon-m-dot"
            } 
            case "5" :{
                text="right"
                return "image://theme/icon-m-right"
            }
            case "7" :{
                text="down"
                return "image://theme/icon-m-down"  
            }
            default: return ""
        }
    }
    onPressed: {
        if (_feedbackEffect) {
            _feedbackEffect.play()
        }
    }
    Image
    {                       
        id: arrowIcon
        anchors.centerIn: parent           
        source: getSource(gridId)
    }
    
}
