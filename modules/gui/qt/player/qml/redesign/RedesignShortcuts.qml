// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Controls as C
import VLC.MainInterface
import VLC.Dialogs

RedesignShortcutEditor {
    id: root
    property string pendingName: ""
    property string pendingShortcut: ""
    signal saved()
    RedesignPreferences { id: draft; ctx: MainCtx }
    shortcuts: draft.shortcutCatalog()
    dirty: draft.dirty
    errorMessage: draft.errorMessage
    values: {
        draft.revision
        const values = {}
        for (const row of shortcuts) {
            values[row.name] = draft.value(row.name)
            if (row.globalName) values[row.globalName] = draft.value(row.globalName)
        }
        return values
    }
    onAboutToShow: draft.discard()
    onCancelRequested: { draft.discard(); close() }
    onSaveRequested: if (draft.save()) { root.saved(); close() }
    onClearRequested: name => draft.assignShortcut(name, "")
    onCaptureRequested: (name, key, modifiers) => {
        const shortcut = draft.shortcutForKey(key, modifiers)
        if (!shortcut.length) return
        const conflicts = draft.shortcutConflicts(name, shortcut)
        if (conflicts.length) {
            pendingName = name; pendingShortcut = shortcut
            conflictText.text = qsTr("%1 is already used for %2. Reassign it?").arg(shortcut).arg(conflicts.map(row => row.title).join(", "))
            conflictDialog.open()
        } else draft.assignShortcut(name, shortcut)
    }
    C.Dialog {
        id: conflictDialog
        parent: root.contentItem
        anchors.centerIn: parent
        width: Math.min(root.availableWidth, root.theme.dp(440))
        modal: true
        title: qsTr("Shortcut already in use")
        standardButtons: C.Dialog.Yes | C.Dialog.Cancel
        palette.window: root.theme.panel; palette.text: root.theme.bright; palette.buttonText: root.theme.bright; palette.button: root.theme.background
        background: Rectangle { color: root.theme.panel; radius: root.theme.dp(8); border.color: root.theme.border }
        contentItem: Text { id: conflictText; color: root.theme.bright; font.pixelSize: root.theme.dp(14); wrapMode: Text.WordWrap }
        onAccepted: draft.assignShortcut(root.pendingName, root.pendingShortcut, true)
    }
}
