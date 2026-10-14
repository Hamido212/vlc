// SPDX-License-Identifier: GPL-2.0-or-later
#include "redesign_preferences.hpp"
#include <vlc_configuration.h>
#include <vlc_modules.h>
#include <vlc_plugin.h>
#include <cmath>
#include <algorithm>
#include <QFileDialog>
#include <QColorDialog>
#include <QGuiApplication>
#include <QScreen>
#include <QKeyEvent>
#include <QLocale>
#include "util/vlchotkeyconverter.hpp"
#include "../../../../audio_filter/equalizer_presets.h"

namespace {
const eqz_preset_t* equalizerPresetForName(const QString& name)
{
    for (const auto& preset : eqz_preset_10b)
        if (name.compare(qfu(preset.psz_name), Qt::CaseInsensitive) == 0)
            return &preset;
    return nullptr;
}

QString equalizerBandsString(const QVariantList& gains)
{
    QStringList bands;
    const QLocale locale(QLocale::C);
    for (const auto& gain : gains)
        bands.append(locale.toString(gain.toDouble(), 'g', 9));
    return bands.join(QLatin1Char(' '));
}

QString categoryFor(const QString& name, int subcat)
{
    if (name.startsWith(QLatin1String("key-")) || name.startsWith(QLatin1String("global-key-"))
        || name.startsWith(QLatin1String("hotkeys-")) || name.startsWith(QLatin1String("mouse-"))
        || name.endsWith(QLatin1String("-jump-size"))) return QStringLiteral("controls");
    if (name.startsWith(QLatin1String("sub-")) || name.startsWith(QLatin1String("subsdec-"))
        || name.startsWith(QLatin1String("freetype-")) || name == QLatin1String("spu")) return QStringLiteral("subtitles");
    if (name.startsWith(QLatin1String("record")) || subcat / 100 == 5) return QStringLiteral("recording");
    if (name.contains(QLatin1String("caching")) || name.startsWith(QLatin1String("avcodec-"))
        || subcat == SUBCAT_INPUT_VCODEC || subcat == SUBCAT_INPUT_ACODEC) return QStringLiteral("performance");
    if (subcat == SUBCAT_ADVANCED_NETWORK || subcat == SUBCAT_INPUT_ACCESS
        || name.startsWith(QLatin1String("http-"))) return QStringLiteral("network");
    if (name.startsWith(QLatin1String("metadata-")) || name.contains(QLatin1String("scrobbler"))) return QStringLiteral("privacy");
    if (name.startsWith(QLatin1String("qt-"))) return QStringLiteral("interface");
    switch (subcat / 100) {
    case 2: return QStringLiteral("audio");
    case 3: return subcat == SUBCAT_VIDEO_SUBPIC ? QStringLiteral("subtitles") : QStringLiteral("video");
    case 4: return QStringLiteral("playback");
    case 7: return QStringLiteral("library");
    default: return QStringLiteral("general");
    }
}
}

RedesignPreferences::RedesignPreferences(QObject* parent) : QObject(parent)
{
    m_saveTimer.setSingleShot(true);
    m_saveTimer.setInterval(300);
    connect(&m_saveTimer, &QTimer::timeout, this, [this]() { if (m_autoSave && dirty()) save(); });
    size_t count = 0;
    module_t** modules = module_list_get(&count);
    for (size_t i = 0; i < count; ++i) {
        unsigned size = 0;
        module_config_t* configs = module_config_get(modules[i], &size);
        int subcat = SUBCAT_UNKNOWN;
        for (unsigned j = 0; j < size; ++j) {
            const module_config_t& cfg = configs[j];
            if (cfg.i_type == CONFIG_SUBCATEGORY) { subcat = cfg.value.i; continue; }
            if (!CONFIG_ITEM(cfg.i_type) || !cfg.psz_name || !cfg.psz_text
                || subcat == SUBCAT_HIDDEN || subcat == SUBCAT_UNKNOWN) continue;
            const QString name = qfu(cfg.psz_name);
            m_catalog.append({name, categoryFor(name, subcat), qtr(cfg.psz_text)});
        }
        module_config_free(configs);
    }
    module_list_free(modules);
    std::sort(m_catalog.begin(), m_catalog.end(), [](const Entry& a, const Entry& b) {
        return QString::localeAwareCompare(a.title, b.title) < 0;
    });
}

void RedesignPreferences::setAutoSave(bool enabled)
{
    if (m_autoSave == enabled) return;
    m_autoSave = enabled;
    if (!enabled) m_saveTimer.stop();
    else if (dirty()) m_saveTimer.start();
    emit autoSaveChanged();
}

void RedesignPreferences::setCtx(MainCtx* ctx)
{
    if (m_ctx == ctx) return;
    m_ctx = ctx;
    emit ctxChanged();
}

QVariant RedesignPreferences::read(const QByteArray& name)
{
    const auto* cfg = config_FindConfig(name.constData());
    if (!cfg) return {};
    switch (CONFIG_CLASS(cfg->i_type)) {
    case CONFIG_ITEM_BOOL: return bool(config_GetInt(name.constData()));
    case CONFIG_ITEM_INTEGER: return QVariant::fromValue<qlonglong>(config_GetInt(name.constData()));
    case CONFIG_ITEM_FLOAT: return config_GetFloat(name.constData());
    case CONFIG_ITEM_STRING: {
        char* text = config_GetPsz(name.constData());
        const QString result = qfu(text ? text : "");
        free(text);
        return result;
    }
    default: return {};
    }
}

void RedesignPreferences::write(const QByteArray& name, const QVariant& value)
{
    const auto* cfg = config_FindConfig(name.constData());
    if (!cfg) return;
    switch (CONFIG_CLASS(cfg->i_type)) {
    case CONFIG_ITEM_BOOL:
    case CONFIG_ITEM_INTEGER: config_PutInt(name.constData(), value.toLongLong()); break;
    case CONFIG_ITEM_FLOAT: config_PutFloat(name.constData(), value.toFloat()); break;
    case CONFIG_ITEM_STRING: config_PutPsz(name.constData(), value.toString().toUtf8().constData()); break;
    }
}

QVariant RedesignPreferences::value(const QString& name) const
{
    if (name == QLatin1String("redesign-repeat"))
        return value(QStringLiteral("repeat")).toBool() ? 1 : value(QStringLiteral("loop")).toBool() ? 2 : 0;
    if (name == QLatin1String("redesign-after-playback"))
        return value(QStringLiteral("play-and-exit")).toBool() ? 1 : value(QStringLiteral("play-and-pause")).toBool() ? 2 : 0;
    if (name.startsWith(QLatin1String("filter:"))) {
        const auto parts = name.split(QLatin1Char(':'));
        return parts.size() == 3 && value(parts[1]).toString().split(QLatin1Char(':')).contains(parts[2]);
    }

    const auto it = m_edits.constFind(name);
    return it == m_edits.cend() ? read(name.toUtf8()) : *it;
}

QVariantMap RedesignPreferences::equalizerPreset(const QString& name) const
{
    const auto* preset = equalizerPresetForName(name);
    if (!preset) return {};
    QVariantList gains;
    for (int i = 0; i < EQZ_BANDS_MAX; ++i)
        gains.append(std::clamp(preset->f_amp[i], -20.f, 20.f));
    return {{QStringLiteral("gains"), gains},
        {QStringLiteral("preamp"), std::clamp(preset->f_preamp, -20.f, 20.f)}};
}

QVariantMap RedesignPreferences::equalizerState() const
{
    if (!config_FindConfig("equalizer-bands") || !config_FindConfig("equalizer-preamp")
        || !config_FindConfig("equalizer-vlcfreqs")) return {};

    static const char* const vlcLabels[EQZ_BANDS_MAX] = {
        N_("60 Hz"), N_("170 Hz"), N_("310 Hz"), N_("600 Hz"), N_("1 KHz"),
        N_("3 KHz"), N_("6 KHz"), N_("12 KHz"), N_("14 KHz"), N_("16 KHz")};
    static const char* const isoLabels[EQZ_BANDS_MAX] = {
        N_("31 Hz"), N_("63 Hz"), N_("125 Hz"), N_("250 Hz"), N_("500 Hz"),
        N_("1 KHz"), N_("2 KHz"), N_("4 KHz"), N_("8 KHz"), N_("16 KHz")};
    const bool vlcFrequencies = value(QStringLiteral("equalizer-vlcfreqs")).toBool();
    const auto* frequencies = vlcFrequencies ? f_vlc_frequency_table_10b : f_iso_frequency_table_10b;
    const auto* labels = vlcFrequencies ? vlcLabels : isoLabels;
    QVariantList frequencyValues, frequencyLabels, gains;
    for (int i = 0; i < EQZ_BANDS_MAX; ++i) {
        frequencyValues.append(frequencies[i]);
        frequencyLabels.append(qtr(labels[i]));
        gains.append(0.f);
    }

    const QString preset = value(QStringLiteral("equalizer-preset")).toString();
    const QString bands = value(QStringLiteral("equalizer-bands")).toString().simplified();
    if (bands.isEmpty()) {
        const auto data = equalizerPreset(preset);
        if (!data.isEmpty()) gains = data.value(QStringLiteral("gains")).toList();
    } else {
        const auto values = bands.split(QLatin1Char(' '), Qt::SkipEmptyParts);
        const QLocale locale(QLocale::C);
        for (int i = 0; i < EQZ_BANDS_MAX && i < values.size(); ++i) {
            bool valid;
            const float gain = locale.toFloat(values[i], &valid);
            if (!valid || !std::isfinite(gain)) break;
            gains[i] = std::clamp(gain, -20.f, 20.f);
        }
    }
    return {{QStringLiteral("frequencyLabels"), frequencyLabels},
        {QStringLiteral("frequencies"), frequencyValues}, {QStringLiteral("gains"), gains},
        {QStringLiteral("preamp"), value(QStringLiteral("equalizer-preamp"))},
        {QStringLiteral("preset"), preset}, {QStringLiteral("minimum"), -20},
        {QStringLiteral("maximum"), 20}};
}

bool RedesignPreferences::stageEqualizerPreset(const QString& name)
{
    return stage(QStringLiteral("equalizer-preset"), name);
}

bool RedesignPreferences::stageEqualizerBand(int index, double gain)
{
    if (index < 0 || index >= EQZ_BANDS_MAX || !std::isfinite(gain)
        || gain < -20. || gain > 20.) return false;
    auto gains = equalizerState().value(QStringLiteral("gains")).toList();
    if (gains.size() != EQZ_BANDS_MAX) return false;
    gains[index] = float(gain);
    return stage(QStringLiteral("equalizer-bands"), equalizerBandsString(gains));
}

bool RedesignPreferences::stageEqualizerPreamp(double gain)
{
    if (!std::isfinite(gain) || gain < -20. || gain > 20.) return false;
    return stage(QStringLiteral("equalizer-preamp"), float(gain));
}

QVariantMap RedesignPreferences::describe(const QString& name) const
{
    if (name == QLatin1String("redesign-repeat") || name == QLatin1String("redesign-after-playback")) {
        const bool repeat = name == QLatin1String("redesign-repeat");
        const QStringList labels = repeat ? QStringList{qtr("Off"), qtr("Current item"), qtr("All items")}
            : QStringList{qtr("Stop"), qtr("Quit VLC"), qtr("Pause on the last frame")};
        QVariantList choices;
        for (int i = 0; i < labels.size(); ++i) choices.append(QVariantMap{{QStringLiteral("label"), labels[i]}, {QStringLiteral("value"), i}});
        return {{QStringLiteral("kind"), QStringLiteral("integer")}, {QStringLiteral("title"), repeat ? qtr("Repeat") : qtr("When playback finishes")},
            {QStringLiteral("choices"), choices}, {QStringLiteral("defaultValue"), 0}, {QStringLiteral("value"), value(name)}};
    }
    if (name.startsWith(QLatin1String("filter:"))) {
        const auto parts = name.split(QLatin1Char(':'));
        if (parts.size() != 3 || !module_exists(parts[2].toUtf8().constData())) return {};
        return {{QStringLiteral("kind"), QStringLiteral("bool")}, {QStringLiteral("title"), parts[2]},
            {QStringLiteral("value"), value(name)}, {QStringLiteral("defaultValue"), false}};
    }

    const QByteArray bytes = name.toUtf8();
    const auto* cfg = config_FindConfig(bytes.constData());
    if (!cfg || !CONFIG_ITEM(cfg->i_type)) return {};
    QVariantMap result{{QStringLiteral("name"), name}, {QStringLiteral("title"), qtr(cfg->psz_text ? cfg->psz_text : cfg->psz_name)},
        {QStringLiteral("help"), qtr(cfg->psz_longtext ? cfg->psz_longtext : "")}, {QStringLiteral("value"), value(name)}};
    QVariantList choices;
    QString kind;
    switch (CONFIG_CLASS(cfg->i_type)) {
    case CONFIG_ITEM_BOOL:
        kind = QStringLiteral("bool"); result.insert(QStringLiteral("defaultValue"), bool(cfg->orig.i)); break;
    case CONFIG_ITEM_INTEGER: {
        kind = QStringLiteral("integer");
        result.insert(QStringLiteral("defaultValue"), QVariant::fromValue<qlonglong>(cfg->orig.i));
        result.insert(QStringLiteral("minimum"), QVariant::fromValue<qlonglong>(cfg->min.i));
        result.insert(QStringLiteral("maximum"), QVariant::fromValue<qlonglong>(cfg->max.i));
        int64_t* values = nullptr; char** labels = nullptr;
        const ssize_t count = config_GetIntChoices(bytes.constData(), &values, &labels);
        for (ssize_t i = 0; i < count; ++i) {
            choices.append(QVariantMap{{QStringLiteral("label"), qfu(labels[i])}, {QStringLiteral("value"), QVariant::fromValue<qlonglong>(values[i])}});
            free(labels[i]);
        }
        free(values); free(labels);
        break;
    }
    case CONFIG_ITEM_FLOAT:
        kind = QStringLiteral("float"); result.insert(QStringLiteral("defaultValue"), cfg->orig.f);
        result.insert(QStringLiteral("minimum"), cfg->min.f); result.insert(QStringLiteral("maximum"), cfg->max.f); break;
    case CONFIG_ITEM_STRING: {
        kind = cfg->i_type == CONFIG_ITEM_PASSWORD ? QStringLiteral("password") : QStringLiteral("string");
        result.insert(QStringLiteral("defaultValue"), qfu(cfg->orig.psz ? cfg->orig.psz : ""));
        char** values = nullptr; char** labels = nullptr;
        const ssize_t count = config_GetPszChoices(bytes.constData(), &values, &labels);
        for (ssize_t i = 0; i < count; ++i) {
            choices.append(QVariantMap{{QStringLiteral("label"), qfu(labels[i])}, {QStringLiteral("value"), qfu(values[i])}});
            free(values[i]); free(labels[i]);
        }
        free(values); free(labels);
        break;
    }
    }
    QString editor;
    switch (cfg->i_type) {
    case CONFIG_ITEM_LOADFILE: case CONFIG_ITEM_SAVEFILE: editor = QStringLiteral("file"); break;
    case CONFIG_ITEM_DIRECTORY: editor = QStringLiteral("directory"); break;
    case CONFIG_ITEM_RGB: editor = QStringLiteral("color"); break;
    }
    if (name == QLatin1String("qt-fullscreen-screennumber")) {
        choices.append(QVariantMap{{QStringLiteral("label"), qtr("Current screen")}, {QStringLiteral("value"), -1}});
        const auto screens = QGuiApplication::screens();
        for (int i = 0; i < screens.size(); ++i)
            choices.append(QVariantMap{{QStringLiteral("label"), screens[i]->name()}, {QStringLiteral("value"), i}});
    }
    result.insert(QStringLiteral("editor"), editor);
    result.insert(QStringLiteral("kind"), kind);
    result.insert(QStringLiteral("choices"), choices);
    return result;
}

bool RedesignPreferences::stage(const QString& name, const QVariant& proposed)
{
    if (name == QLatin1String("equalizer-preset")) {
        const auto data = equalizerPreset(proposed.toString());
        if (data.isEmpty() || !config_FindConfig("equalizer-preset")
            || !config_FindConfig("equalizer-bands") || !config_FindConfig("equalizer-preamp")) return false;
        if (!stage(QStringLiteral("equalizer-bands"), equalizerBandsString(data.value(QStringLiteral("gains")).toList()))
            || !stageEqualizerPreamp(data.value(QStringLiteral("preamp")).toDouble())) return false;
    }
    if (name == QLatin1String("redesign-repeat") || name == QLatin1String("redesign-after-playback")) {
        const int choice = proposed.toInt();
        if (choice < 0 || choice > 2) return false;
        const bool repeat = name == QLatin1String("redesign-repeat");
        stage(repeat ? QStringLiteral("repeat") : QStringLiteral("play-and-exit"), choice == 1);
        return stage(repeat ? QStringLiteral("loop") : QStringLiteral("play-and-pause"), choice == 2);
    }
    if (name.startsWith(QLatin1String("filter:"))) {
        const auto parts = name.split(QLatin1Char(':'));
        if (parts.size() != 3 || !module_exists(parts[2].toUtf8().constData())) return false;
        if (proposed.toBool() && parts[1] == QLatin1String("audio-filter")
            && parts[2] == QLatin1String("equalizer")
            && value(QStringLiteral("equalizer-bands")).toString().trimmed().isEmpty()) {
            // The filter needs explicit bands even when no audio output is running.
            const auto gains = equalizerState().value(QStringLiteral("gains")).toList();
            if (gains.size() != EQZ_BANDS_MAX
                || !stage(QStringLiteral("equalizer-bands"), equalizerBandsString(gains))) return false;
        }
        auto filters = value(parts[1]).toString().split(QLatin1Char(':'), Qt::SkipEmptyParts);
        filters.removeAll(parts[2]);
        if (proposed.toBool()) filters.append(parts[2]);
        return stage(parts[1], filters.join(QLatin1Char(':')));
    }

    const auto* cfg = config_FindConfig(name.toUtf8().constData());
    if (!cfg || !CONFIG_ITEM(cfg->i_type)) return false;
    QVariant normalized;
    bool valid = true;
    switch (CONFIG_CLASS(cfg->i_type)) {
    case CONFIG_ITEM_BOOL: normalized = proposed.toBool(); break;
    case CONFIG_ITEM_INTEGER: {
        const qlonglong v = proposed.toLongLong(&valid);
        valid = valid && (cfg->min.i == cfg->max.i || (v >= cfg->min.i && v <= cfg->max.i));
        normalized = QVariant::fromValue(v); break;
    }
    case CONFIG_ITEM_FLOAT: {
        const double v = proposed.toDouble(&valid);
        valid = valid && std::isfinite(v) && (cfg->min.f == cfg->max.f || (v >= cfg->min.f && v <= cfg->max.f));
        normalized = float(v); break;
    }
    case CONFIG_ITEM_STRING: normalized = proposed.toString(); break;
    default: valid = false; break;
    }
    if (!valid) {
        m_invalid.insert(name);
        m_error = qtr("Enter a value within the allowed range.");
        ++m_revision; emit changed(); return false;
    }
    m_invalid.remove(name);
    if (QStringList{QStringLiteral("hue"), QStringLiteral("brightness"), QStringLiteral("contrast"), QStringLiteral("saturation"), QStringLiteral("gamma")}.contains(name))
        stage(QStringLiteral("filter:video-filter:adjust"), true);

    if (normalized == read(name.toUtf8())) m_edits.remove(name);
    else m_edits.insert(name, normalized);
    if (m_invalid.isEmpty())
        m_error.clear();
    ++m_revision;
    emit changed();
    if (m_autoSave) m_saveTimer.start();
    return true;
}

void RedesignPreferences::reset(const QString& name)
{
    const auto data = describe(name);
    if (!data.isEmpty()) stage(name, data.value(QStringLiteral("defaultValue")));
}

void RedesignPreferences::discard()
{
    m_saveTimer.stop();
    m_edits.clear(); m_invalid.clear(); m_error.clear(); ++m_revision; emit changed();
}

bool RedesignPreferences::save()
{
    m_saveTimer.stop();
    if (!m_ctx || !m_invalid.isEmpty()) return false;
    QVariantMap previous;
    for (auto it = m_edits.cbegin(); it != m_edits.cend(); ++it) {
        previous.insert(it.key(), read(it.key().toUtf8()));
        write(it.key().toUtf8(), it.value());
    }
    if (config_SaveConfigFile(m_ctx->getIntf()) != 0) {
        for (auto it = previous.cbegin(); it != previous.cend(); ++it) write(it.key().toUtf8(), it.value());
        m_error = qtr("The preferences file could not be saved. Your edits are still open.");
        ++m_revision; emit changed(); return false;
    }
    m_ctx->reloadPrefs();
    discard();
    return true;
}

QVariantList RedesignPreferences::catalog(const QString& category, const QString& search) const
{
    QVariantList result;
    for (const auto& entry : m_catalog) {
        if (!search.isEmpty()) {
            if (!entry.name.contains(search, Qt::CaseInsensitive) && !entry.title.contains(search, Qt::CaseInsensitive)) continue;
        } else if (entry.category != category) continue;
        result.append(QVariantMap{{QStringLiteral("name"), entry.name}, {QStringLiteral("title"), entry.title}});
    }
    return result;
}

QString RedesignPreferences::choosePath(const QString& name)
{
    const auto* cfg = config_FindConfig(name.toUtf8().constData());
    if (!cfg) return {};
    const QString initial = value(name).toString();
    switch (cfg->i_type) {
    case CONFIG_ITEM_DIRECTORY: return QFileDialog::getExistingDirectory(nullptr, qtr("Select folder"), initial);
    case CONFIG_ITEM_SAVEFILE: return QFileDialog::getSaveFileName(nullptr, qtr("Select file"), initial);
    case CONFIG_ITEM_LOADFILE: return QFileDialog::getOpenFileName(nullptr, qtr("Select file"), initial);
    default: return {};
    }
}

QString RedesignPreferences::chooseColor(const QString& initial)
{
    const QColor color = QColorDialog::getColor(QColor(initial), nullptr, qtr("Choose color"));
    return color.isValid() ? color.name() : QString();
}

QVariantList RedesignPreferences::shortcutCatalog() const
{
    struct Shortcut { QString name, title, group; };
    const Shortcut shortcuts[] = {
        {QStringLiteral("key-toggle-fullscreen"), qtr("Toggle fullscreen"), qtr("Basic")},
        {QStringLiteral("key-leave-fullscreen"), qtr("Exit fullscreen / close dialog"), qtr("Basic")},
        {QStringLiteral("key-position"), qtr("Show playback position and time"), qtr("Basic")},
        {QStringLiteral("key-intf-show"), qtr("Show interface controls in fullscreen"), qtr("Basic")},
        {QStringLiteral("key-play-pause"), qtr("Play / pause"), qtr("Playback")},
        {QStringLiteral("key-stop"), qtr("Stop playback"), qtr("Playback")},
        {QStringLiteral("key-next"), qtr("Next track"), qtr("Playback")},
        {QStringLiteral("key-prev"), qtr("Previous track"), qtr("Playback")},
        {QStringLiteral("key-program-sid-next"), qtr("Next program / Service ID"), qtr("Playback")},
    };
    QVariantList result;
    for (const auto& row : shortcuts) {
        const auto* cfg = config_FindConfig(row.name.toUtf8().constData());
        if (!cfg || cfg->i_type != CONFIG_ITEM_KEY) continue;
        const QString global = QStringLiteral("global-") + row.name;
        result.append(QVariantMap{{QStringLiteral("name"), row.name}, {QStringLiteral("title"), row.title},
            {QStringLiteral("group"), row.group}, {QStringLiteral("globalName"), config_FindConfig(global.toUtf8().constData()) ? global : QString()}});
    }
    return result;
}

QString RedesignPreferences::shortcutForKey(int key, int modifiers) const
{
    QKeyEvent event(QEvent::KeyPress, key, Qt::KeyboardModifiers::fromInt(modifiers));
    return VLCKeyToString(qtEventToVLCKey(&event), false);
}

QVariantList RedesignPreferences::shortcutConflicts(const QString& name, const QString& shortcut) const
{
    QVariantList conflicts;
    if (shortcut.isEmpty()) return conflicts;
    const bool global = name.startsWith(QLatin1String("global-key-"));
    for (const auto& entry : m_catalog) {
        if (entry.name == name || entry.name.startsWith(QLatin1String("global-key-")) != global) continue;
        if (!entry.name.startsWith(global ? QLatin1String("global-key-") : QLatin1String("key-"))) continue;
        if (value(entry.name).toString().split(QLatin1Char('\t')).contains(shortcut, Qt::CaseInsensitive))
            conflicts.append(QVariantMap{{QStringLiteral("name"), entry.name}, {QStringLiteral("title"), entry.title}});
    }
    return conflicts;
}

bool RedesignPreferences::assignShortcut(const QString& name, const QString& shortcut, bool replaceConflicts)
{
    const auto* cfg = config_FindConfig(name.toUtf8().constData());
    if (!cfg || cfg->i_type != CONFIG_ITEM_KEY) return false;
    const auto conflicts = shortcutConflicts(name, shortcut);
    if (!conflicts.isEmpty() && !replaceConflicts) return false;
    for (const auto& conflict : conflicts) {
        const QString other = conflict.toMap().value(QStringLiteral("name")).toString();
        QStringList bindings = value(other).toString().split(QLatin1Char('\t'), Qt::SkipEmptyParts);
        bindings.erase(std::remove_if(bindings.begin(), bindings.end(), [&shortcut](const QString& binding) {
            return binding.compare(shortcut, Qt::CaseInsensitive) == 0;
        }), bindings.end());
        stage(other, bindings.join(QLatin1Char('\t')));
    }
    if (shortcut.isEmpty()) return stage(name, QString());
    QStringList bindings = value(name).toString().split(QLatin1Char('\t'), Qt::SkipEmptyParts);
    // Replace the displayed binding while retaining alternate and media keys.
    if (!bindings.isEmpty() && !bindings.first().startsWith(QLatin1String("Media ")))
        bindings.removeFirst();
    bindings.removeAll(shortcut);
    bindings.prepend(shortcut);
    return stage(name, bindings.join(QLatin1Char('\t')));
}
