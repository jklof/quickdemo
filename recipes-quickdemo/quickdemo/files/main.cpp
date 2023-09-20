#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include "demo.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    Demo demo;

    // Expose the C++ backend to QML
    engine.rootContext()->setContextProperty("demo", &demo);

    const QUrl url(u"qrc:/quickDemo/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
