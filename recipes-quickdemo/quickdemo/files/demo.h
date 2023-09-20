#ifndef DEMO_H
#define DEMO_H

#include <QObject>
#include <QImage>
#include <QNetworkAccessManager>
#include <memory>

class Demo : public QObject
{
    Q_OBJECT
    std::unique_ptr<QNetworkAccessManager> manager;
public:
    explicit Demo(QObject *parent = nullptr);

    // expose to QML
    Q_INVOKABLE void imageToText(QObject * image, const QString &hfToken);

signals:
    void captionTextReturned(const QString &result);

};

#endif // DEMO_H
