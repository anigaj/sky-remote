import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

import "pages"
import "settings"

ApplicationWindow
{
    id: app
    
    initialPage: Component 
    { 
        ConnectSkyBox { } 
    }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    
    
    Python
    {
        id: python
        Component.onCompleted: 
        {
            addImportPath(Qt.resolvedUrl('.'));
            importModule('helper', function () {});
        }
    } 
}

