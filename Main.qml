import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts

ApplicationWindow {



    visible: true
    minimumWidth: drawingCanvas.width
    minimumHeight: drawingCanvas.height + rowLayout.height + textLabel.height + tokenInput.height + spacer.height
    width: drawingCanvas.width
    height: drawingCanvas.height + rowLayout.height + textLabel.height + tokenInput.height + spacer.height
    title: "Simple Drawing"

    property int pointSize: 5 // Default point size
    property color pointColor: "black" // Default point color
    property string tool : "pen" // default tool is pen

    property string hfToken: "" // Hugging Face token

    Column {
        anchors.fill: parent
        Rectangle {
            width: 512
            height: 512
            color: "white" // Set the background color to white for the canvas
            Canvas {
                id: drawingCanvas
                width: parent.width
                height: parent.height


                // Add properties to store the previous and current mouse positions
                property point prevMousePos: Qt.point(0, 0)
                property point currentMousePos: Qt.point(0, 0)

                onPaint: {
                    var ctx = getContext("2d");
                    if (tool == "pen") {
                        ctx.fillStyle = pointColor;
                        // Draw a line from the previous mouse position to the current mouse position
                        ctx.beginPath();
                        ctx.moveTo(prevMousePos.x, prevMousePos.y);
                        ctx.lineTo(currentMousePos.x, currentMousePos.y);
                        ctx.lineWidth = pointSize;
                        ctx.stroke();
                        ctx.closePath();
                        drawingCanvas.prevMousePos = drawingCanvas.currentMousePos
                    } else if (tool == "clear") {
                        ctx.fillStyle = "white";
                        ctx.fillRect(0, 0, width, height);
                        tool = "pen"
                    }
                }


                onAvailableChanged: {
                    if (drawingCanvas.available) {
                        // Set the initial white background when the Canvas is available
                        var ctx = drawingCanvas.getContext("2d");
                        ctx.fillStyle = "white";
                        ctx.fillRect(0, 0, drawingCanvas.width, drawingCanvas.height);
                    }
                }
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    propagateComposedEvents: true

                    onPressed: {
                        // Set the previous and current mouse positions when pressed
                        drawingCanvas.prevMousePos = Qt.point(mouseX, mouseY);
                        drawingCanvas.currentMousePos = Qt.point(mouseX, mouseY);
                        drawingCanvas.requestPaint();
                    }

                    onPositionChanged: {
                        // Update the current mouse position on position change (mouse move)
                        drawingCanvas.currentMousePos = Qt.point(mouseX, mouseY);
                        drawingCanvas.requestPaint();
                    }

                    onReleased: {
                        // Draw the final line segment when the mouse is released
                        drawingCanvas.prevMousePos = Qt.point(mouseX, mouseY);
                        drawingCanvas.requestPaint();
                    }
                }
            }
        }


        Text {
            id: textLabel
            text: "This is an empty label"
            font.pixelSize: 20
            Layout.alignment: Qt.AlignHCenter
            Connections {
                target: demo // Access the Demo object exposed from C++
                function onCaptionTextReturned(result) {
                    textLabel.text = "Result: " + result;
                }
            }


        }


        Row {
            id: rowLayout
            spacing: 10

            Layout.minimumWidth: 80
            Layout.maximumWidth: 160


            Button {
                text: "Increase size"
                Layout.minimumWidth: 80
                Layout.maximumWidth: 160
                onClicked: {
                    pointSize += 5;
                }
            }

            Button {
                text: "Decrease size"
                Layout.minimumWidth: 80
                Layout.maximumWidth: 160
                onClicked: {
                    pointSize = Math.max(1, pointSize - 5);
                }
            }

            Button {
                text: "Clear"
                Layout.minimumWidth: 80
                Layout.maximumWidth: 160
                onClicked: {
                   tool = "clear"
                   drawingCanvas.requestPaint();
                }
            }

            Button {
                text: "Caption"
                Layout.minimumWidth: 80
                Layout.maximumWidth: 160
                onClicked : {
                    drawingCanvas.grabToImage(function(result) {
                        demo.imageToText(result, hfToken);
                    })
                }
            }

        }


        TextField {
            id: tokenInput
            width: parent.width
            placeholderText: "Enter Hugging Face Token"
            Layout.fillWidth: true
            onTextChanged: {
                // Update the Hugging Face token property whenever the text changes
                hfToken = text;
            }
        }

        Item {
            id: spacer
            Layout.fillHeight: true // Expand to take up empty space
        }

    }
}
