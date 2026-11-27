// SPDX-License-Identifier: GPL-3.0-or-later
// SPDX-FileCopyrightText: 2017-2019 Alejandro Sirgo Rica & Contributors

#include "tildeshotdbusadapter.h"
#include "core/tildeshot.h"
#include "core/tildeshotdaemon.h"

TildeshotDBusAdapter::TildeshotDBusAdapter(QObject* parent)
  : QDBusAbstractAdaptor(parent)
{}

TildeshotDBusAdapter::~TildeshotDBusAdapter() = default;

void TildeshotDBusAdapter::captureScreen()
{
    Tildeshot::instance()->gui(CaptureRequest(CaptureRequest::GRAPHICAL_MODE));
}

void TildeshotDBusAdapter::attachScreenshotToClipboard(const QByteArray& data)
{
    TildeshotDaemon::instance()->attachScreenshotToClipboard(data);
}

void TildeshotDBusAdapter::attachTextToClipboard(const QString& text,
                                                 const QString& notification)
{
    TildeshotDaemon::instance()->attachTextToClipboard(text, notification);
}

void TildeshotDBusAdapter::attachPin(const QByteArray& data)
{
    TildeshotDaemon::instance()->attachPin(data);
}
