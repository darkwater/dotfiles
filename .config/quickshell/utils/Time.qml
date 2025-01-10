pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property var locale: Qt.locale()

    function createDate(): string {
        const date = new Date();
        const hh = date.getHours().toString().padStart(2, 0);
        const mm = date.getMinutes().toString().padStart(2, 0);
        const ss = date.getSeconds().toString().padStart(2, 0);
        const weekday = locale.dayName(date.getDay(), Locale.ShortFormat);
        const month = locale.monthName(date.getMonth(), Locale.ShortFormat);
        const day = date.getDate();

        const ms = date.getMilliseconds();
        timer.interval = 999 - ms;
        timer.running = true;

        return `${weekday} ${day} ${month} ${hh}:${mm}:${ss}`;
    }

    property var time: createDate()

    Timer {
        id: timer
        interval: 1000
        running: true
        onTriggered: parent.time = parent.createDate()
    }
}
