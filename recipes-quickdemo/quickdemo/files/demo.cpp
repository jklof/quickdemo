#include "demo.h"
#include <QDebug>

#include <QImage>
#include <QQuickItemGrabResult>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QBuffer>
#include <QFile>
#include <QDir>

#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>


// basically idea is that this code takes an image, converts
// it to PNG and then uses huggingface API to caption the
// image. result is signalled back to QML code to be used
// as the label for the image.

Demo::Demo(QObject *parent)
    : QObject{parent}
{
    manager = std::make_unique<QNetworkAccessManager>(this);
}


void Demo::imageToText(QObject *image, const QString &hfToken)
{
    qDebug() << "caption the image";

    QQuickItemGrabResult *item = nullptr;
    item = qobject_cast<QQuickItemGrabResult*>(image);
    QImage qi(item->image());

    // Convert the QImage to a QByteArray
    QByteArray imageBytes;
    QBuffer buffer(&imageBytes);
    buffer.open(QIODevice::WriteOnly);
    // Convert the image to RGB format (removing alpha channel)
    QImage rgbImage = qi.convertToFormat(QImage::Format_RGB888);
    // Save the RGB image as PNG
    rgbImage.save(&buffer, "PNG");
    buffer.close();


    // Save the image data to a file for debugging purposes
    QString debugImagePath = "/tmp/debug_image.png";
    QFile debugImageFile(debugImagePath);
    if (debugImageFile.open(QIODevice::WriteOnly))
    {
        debugImageFile.write(imageBytes);
        debugImageFile.close();
        qDebug() << "Image saved to" << debugImagePath << "for debugging purposes.";
    }
    else
    {
        qDebug() << "Failed to open debug image file for writing.";
    }


    // Send the image data to hf to be captioned, using a model that is (for now) available
    QString apiUrl = "https://api-inference.huggingface.co/models/Salesforce/blip-image-captioning-base";

    QNetworkRequest request; // Declare request as a QNetworkRequest object
    request.setUrl(QUrl(apiUrl)); // Set the URL separately
    request.setHeader(QNetworkRequest::ContentTypeHeader, "image/png");
    request.setRawHeader("Authorization", "Bearer " + hfToken.toUtf8()); // API KEY

    emit captionTextReturned("Captioning...");
    QNetworkReply *reply = manager->post(request, imageBytes);
    auto context = this;
    connect(reply, &QNetworkReply::finished, context, [reply, context]() {
        qDebug() << "HTTP finished";
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray response = reply->readAll();
            QJsonDocument jsonResponse = QJsonDocument::fromJson(response);
            // Check if the JSON response is an array with at least one object
            if (jsonResponse.isArray() && !jsonResponse.array().isEmpty()) {
                QString captionText = jsonResponse.array()[0].toObject()["generated_text"].toString();
                qDebug() << "Caption text:" << captionText;
                emit context->captionTextReturned(captionText);
            } else {
                qDebug() << "Invalid JSON response";
                emit context->captionTextReturned("Invalid JSON response");
            }
        } else {
            qDebug() << "Error reply:" << reply->errorString();
            emit context->captionTextReturned("Error occurred while captioning.");
        }
        reply->deleteLater();
    });
    qDebug() << "request sent";
}
