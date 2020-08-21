import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    id: colorDot

    property string text
    property bool highlighted: down
    property string gridId    

    function getColor(id)
    {             
        switch(id) {            
            case "0":{
                text="red"             
                return "red"
            }
            case "1":{
                text="green"
                return "green"
            }
            case "2":{
                text="yellow"
                return "yellow"
            } 
            case "3" :{
                text="blue"
                return "blue"
            }
        }
    }
    onPressed: {
        if (_feedbackEffect) {
            _feedbackEffect.play()
        }
    }
    Rectangle 
    {                       
        id: dot
        anchors.centerIn: parent 
        width: parent.width - Theme.paddingLarge         
        height: width         
        radius: width/2 
        color: getColor(gridId) 
    }
    
}
