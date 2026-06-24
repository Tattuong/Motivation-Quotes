package com.motivationquotesmng.motivationquotes

import android.appwidget.AppWidgetManager
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class QuoteWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: android.content.SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.quote_widget).apply {
                val quote = widgetData.getString("daily_quote", "Stay motivated today!")
                val author = widgetData.getString("daily_author", "Motivation Quotes")
                setTextViewText(R.id.widget_quote, quote)
                setTextViewText(R.id.widget_author, "— $author")
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
