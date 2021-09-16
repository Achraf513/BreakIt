import 'dart:async';

import 'package:app_usage/app_usage.dart';
import 'package:break_it/Models/Appdaily.dart';
import 'package:break_it/Models/RuleModel.dart';
import 'package:break_it/Models/Weekly.dart';
import 'package:break_it/Models/generalData.dart';
import 'package:break_it/Shared/database.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Shared {
  DateTime today = DateTime.now().subtract(
      Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute));
  static final Shared _shared = new Shared._internal();
  late List<RuleModel> rules;
  factory Shared() {
    return _shared;
  }
  Shared._internal();

  //Colors
  int notificationIds = 0;
  static bool blockUser = true;
  static int colorUi = 0xFF430064;
  static int colorPrimaryText = 0xFF430064;
  static int colorPrimaryBackGround = 0xFFFFFFFF;
  static int colorSecondaryBackGround = 0xFFF6F5F6;
  static int colorSecondary2BackGround = 0xFF655C98;

  static const int pieChartColor_yellow = 0xFF58508d;
  static const int pieChartColor_violet = 0xFFbc5090;
  static const int pieChartColor_blue = 0xFFff6361;
  static const int pieChartColor_red = 0xFFffa600;
  static const int pieChartColor_green = 0xFF34ad1d;

  static bool notifyTodayExceededAvarege = false;
  static bool didntnotifyTodayExceededAvarege = true;
  static String selectedLanguage = "English";
  static bool darkThemeOn = false;
  static bool notifyEarlier = false;
  
  //Sentences
  static void flipTheme() {
    if (darkThemeOn) {
      colorUi = 0xFF430064;
      colorPrimaryText = 0xFFFFFFFF;
      colorPrimaryBackGround = 0xFF232323;
      colorSecondaryBackGround = 0xFF3A3A3A;
      colorSecondary2BackGround = 0xFF655C98;
    } else {
      colorUi = 0xFF430064;
      colorPrimaryText = 0xFF430064;
      colorPrimaryBackGround = 0xFFFFFFFF;
      colorSecondaryBackGround = 0xFFF6F5F6;
      colorSecondary2BackGround = 0xFF655C98;
    }
  }

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late Timer? timer;

  Future<int> initShared() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings("@mipmap/ic_launcher");
    var initSettings = new InitializationSettings(android: android);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
    rules = await DataBase.instance.readRules();
    notifyEarlier = (await DataBase.instance.getGeneralData("NotifyEarlier"))!.data=="false"?false:true;
    notifyTodayExceededAvarege = (await DataBase.instance.getGeneralData("NotifyTodayExceededAvarege"))!.data=="false"?false:true;
    selectedLanguage = (await DataBase.instance.getGeneralData("SelectedLanguage"))!.data;
    darkThemeOn = (await DataBase.instance.getGeneralData("DarkModeOn"))!.data=="false"?false:true;
    flipTheme();
    timer = Timer.periodic(Duration(minutes: 5), (Timer t) => checkForRules());
    return 1;
  }

  Future onSelectNotification(String? payload) {
    return Future.delayed(Duration(seconds: 0));
  }

  showNotification(String title, String body) async {
    var android = AndroidNotificationDetails(
        "channel id", "channel NAME", "CHANNEL DESCRIPTION",
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var platform = NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.show(
        notificationIds, title, body, platform);
  }

  static int extractTimeInMinutes(String time){
    String time = "5h 21min";
    List<String> timeSplitted= time.split("h");
    int totalTimeInMin = 0;
    if(timeSplitted.length>1){
      totalTimeInMin += int.parse(timeSplitted[0])*60;
      timeSplitted.removeAt(0);
    }
    timeSplitted = timeSplitted[0].split("min");
    totalTimeInMin += int.parse(timeSplitted[0]);
    return totalTimeInMin;
  }
   checkForRules() async {
    if(notifyTodayExceededAvarege && didntnotifyTodayExceededAvarege){
      int todaysUsage = extractTimeInMinutes( await getTodayTimeOn());
      int avarageUsage = extractTimeInMinutes( await getAvarageThisWeekTimeOn(0));
      if(todaysUsage>avarageUsage){
        showNotification("BreakIt!", "Today's usage limit exceeded the Avarage usage!");
        didntnotifyTodayExceededAvarege = false;
      }
    }
    rules = await DataBase.instance.readRulesWithNotifLeft();
    List<AppUsageInfo> appList = await SharedData()
        .getUsageStats(today, today.add(Duration(days: 1)), false);
    for (var rule in rules) {
      if (rule.notificationFrequency != 0) {
        for (var app in appList) {
          if (app.packageName == rule.appPackageName) {
            int earlierNotifier = notifyEarlier?5:0;
            if ((rule.usageLimitInH * 60 + rule.usageLimitInMin) <
               ( app.usage.inMinutes + earlierNotifier)) {
              rule.todaysNotifications -= 1;
              DataBase.instance.updateRule(rule);
              showNotification(
                  "BreakIt!", rule.appName + " usage limit exceeded");
              notificationIds += 1;
            }
            break;
          }
        }
      }
    }
  }
  static Future<String> getAvarageThisWeekTimeOn(int recrusionTimes) async {
    DateTime now = DateTime.now();
    DateTime startOfthisWeek =
        now.subtract(Duration(hours: now.hour, minutes: now.minute));
    while (startOfthisWeek.weekday != DateTime.monday) {
      startOfthisWeek = startOfthisWeek.subtract(Duration(days: 1));
    }
    //This.idWeek = ThisWeeksLastDay.substract(Duratuin(hours : 24))
    String idWeek = startOfthisWeek.day.toString() +
        startOfthisWeek.month.toString() +
        startOfthisWeek.add(Duration(days: 6)).day.toString() +
        startOfthisWeek.add(Duration(days: 6)).month.toString() +
        startOfthisWeek.year.toString();

    List<WeeklyInfo>? result = await DataBase.instance.readWeeklyInfo(idWeek);
    if (result != null) { 
        int totalUsage = 0;
        for (var weeklyInfo in result) {
          int usage = (weeklyInfo.usageInHours * 60).toInt();
          totalUsage += usage;
        }
        totalUsage = totalUsage ~/ result.length;
        int totalHours = (totalUsage ~/ 60);
        int totalMinutes = totalUsage - (totalUsage ~/ 60) * 60;
        String hoursText = totalHours != 0 ? totalHours.toString() + "h" : "";
        String minutesText =
            totalMinutes != 0 ? totalMinutes.toString() + "min" : "";
        return hoursText + minutesText;
    }else if(recrusionTimes>3){
      return getTodayTimeOn();
    }
     else {
      Future.delayed(Duration(seconds: 1));
      recrusionTimes+=1;
      return getAvarageThisWeekTimeOn(recrusionTimes);
    }
  }

  static Future<String> getTodayTimeOn() async {
    WeeklyInfo? todaysWeeklyInfo =
        await DataBase.instance.getTodaysWeeklyInfo();
    if (todaysWeeklyInfo != null) {
      int usage = (todaysWeeklyInfo.usageInHours * 60).toInt();
      int hours = usage ~/ 60;
      int minutes = usage - (usage ~/ 60) * 60;
      String hoursText = hours != 0 ? hours.toString() + "h" : "";
      String minutesText = minutes != 0 ? minutes.toString() + "min" : "";
      return hoursText + minutesText;
    } else {
      Future.delayed(Duration(seconds: 1));
      return getTodayTimeOn();
    }
  }
  static Future<String?> getAvarageThisWeekCategory() async {
    String test = await DataBase.instance.getThisWeeksCategory() ?? "";
    return SharedData().dictionary[Shared.selectedLanguage]?[test];
  }

  static Future<String?> getTodayCategory() async {
    String test = await DataBase.instance.getTodaysDailyCategory() ?? "";
    return SharedData().dictionary[Shared.selectedLanguage]?[test];
  }
}

class SharedData {
  Map<String, Map<String, String>> dictionary = {
    "English": {
      "What is BreakIt?": "What is BreakIt?",
      "BreakIt is an Android application developed by \"Affes Achraf\" as an internship project supervised by \"WebGraphique\" it's an app that helps you improve your self control and time management.":
          "BreakIt is an Android application developed by \"Affes Achraf\" as an internship project supervised by \"WebGraphique\" it's an app that helps you improve your self control and time management.",
      "Main functionalities of BreakIt?": "Main functionalities of BreakIt?",
      "Through this app you can check your mobile phone usage statistics, top used apps, top used category, average usage etc ...\nThe app also includes details for each installed app, it also allows you to set down rules of usage for each application so that it notifies you when the time limit has exceeded.":
          "Through this app you can check your mobile phone usage statistics, top used apps, top used category, average usage etc ...\nThe app also includes details for each installed app, it also allows you to set down rules of usage for each application so that it notifies you when the time limit has exceeded.",
      "Does it consume battery?": "Does it consume battery?",
      "Our app updates its data once every 15min in the background or immediately after entering the app and therefore the power consumption is very low.":
          "Our app updates its data once every 15min in the background or immediately after entering the app and therefore the power consumption is very low.",
      "Usage Dashboard": "Usage Dashboard",
      "Activities": "Activities",
      "Rules": "Rules",
      "New Rule": "New Rule",
      "Application": "Application",
      "Monday": "Monday",
      "Tuesday": "Tuesday",
      "Wednesday": "Wednesday",
      "Thursday": "Thursday",
      "Friday": "Friday",
      "Saturday": "Saturday",
      "Sunday": "Sunday",
      "TODAY'S STATES": "TODAY'S STATES",
      "AVERAGE THIS WEEK": "AVERAGE THIS WEEK",
      "Category": "Category",
      "Total Usage": "Total Usage",
      "Search by application": "Search by application",
      "Usage Percentage": "Usage Percentage",
      "Used For": "Used For",
      "Usage Limit": "Usage Limit",
      "Hour": "Hour",
      "Hours": "Hours",
      "Min": "Min",
      "Cancel": "Cancel",
      "Submit": "Submit",
      "Notification Frequency": "Notification Frequency",
      'Once daily': 'Once daily',
      'Twice daily': 'Twice daily',
      '3 times a day': '3 times a day',
      '4 times a day': '4 times a day',
      '5 times a day': '5 times a day',
      "General": "General",
      "5 min before the usage limit reaches":"5 min before the usage limit reaches",
      "If today's time on exceeded the average":"If today's time on exceeded the average",
      "Notify me :":"Notify me :",
      "Notifications": "Notifications",
      "Rate Us": "Rate Us",
      "About": "About",
      "Dark Theme": "Dark Theme",
      "FeedBack": "FeedBack",
      "Report a bug": "Report a bug",
      "Send FeedBack": "Send FeedBack",
      "Settings": "Settings",
      "Language": "Language",
      "English": "English",
      "French": "French",
      "Spanish": "Spanish",
      "German": "German",
      "System": "System",
      "Audio": "Audio",
      "Game": "Game",
      "Image": "Image",
      "Navigation": "Navigation",
      "News": "News",
      "Yes":"Yes",
      "No":"No",
      "Okay":"Okay",
      'Deleted successfully':'Deleted successfully',
      'The rule was successfully deleted, click okay to continue.':'The rule was successfully deleted, click "Okay" to continue.',
      "Productivity": "Productivity",
      "Social": "Social",
      "Video": "Video",
      "Unkown": "Unkown",
      "Other": "Other",
      "Delete": "Delete",
      "Delete Rule?":"Delete Rule?",
      'Are you sure you want to delete this rule?':"Are you sure you want to delete this rule?",
      "per day": "per day",
      "Report a bug \nOr Request a feature":
          "Report a bug \nOr Request a feature",
      "Title": "Title",
      "please enter a valid Title": "please enter a valid Title",
      "Description": "Description",
      "please enter a valid Description": "please enter a valid Description",
      'Thank You!': 'Thank You!',
      "Thank you for reporting the bug.\nIt is very helpful for us!":
          "Thank you for reporting the bug.\nIt is very helpful for us!",
      "Sorry!": "Sorry!",
      "It seems like you have some internet problems.":
          "It seems like you have some internet problems.",
      'Close': 'Close',
      "please enter a valid FeedBack": "please enter a valid FeedBack",
      'Thank you for your feedBack.\nIt is very helpful for us!':
          'Thank you for your feedBack.\nIt is very helpful for us!',
      "Edit rule": "Edit rule",
      "Welcome to BreakIt Rules Functionality":
          "Welcome to BreakIt's Rules Functionality",
      "In order to add a usage rule to any installed app, Simply click on the plus button and fill in with the desired usage limits, then click on 'submit'.":"In order to add a usage rule to any installed app, Simply click on the plus button and fill in with the desired usage limits, then click on 'submit'.",
    },
    "French": {
      "What is BreakIt?": "Qu'est-ce que BreakIt ?",
      "BreakIt is an Android application developed by \"Affes Achraf\" as an internship project supervised by \"WebGraphique\" it's an app that helps you improve your self control and time management.":
          "BreakIt est une application Android développée par \"Affes Achraf\" en tant que projet de stage encadré par \"WebGraphique\" c'est une application qui vous aide à améliorer votre maîtrise de soi et la gestion du temps.",
      "Main functionalities of BreakIt?":
          "Principales fonctionnalités de BreakIt?",
      "Through this app you can check your mobile phone usage statistics, top used apps, top used category, average usage etc ...\nThe app also includes details for each installed app, it also allows you to set down rules of usage for each application so that it notifies you when the time limit has exceeded.":
          "Grâce à cette application, vous pouvez consulter les statistiques d'utilisation de votre téléphone portable, les applications les plus utilisées, la catégorie la plus utilisée, l'utilisation moyenne, etc.\nL'application comprend également des détails pour chaque application installée, elle vous permet également de définir des règles d'utilisation pour chaque application afin qu'il vous avertisse lorsque le délai est dépassé.",
      "Does it consume battery?": "Est-ce que ça consomme de la batterie ?",
      "Our app updates its data once every 15min in the background or immediately after entering the app and therefore the power consumption is very low.":
          "Notre application met à jour ses données toutes les 15 minutes en arrière-plan ou immédiatement après être entré dans l'application et la consommation d'énergie est donc très faible.",
      "Usage Dashboard": "Tableau de bord d'utilisation",
      "Activities": "Activités",
      "Rules": "Règles",
      "New Rule": "Nouvelle règle",
      "Application": "Application",
      "Monday": "Lundi",
      "Tuesday": "Mardi",
      "Wednesday": "Mercredi",
      "Thursday": "Jeudi",
      "Friday": "Vendredi",
      "Saturday": "Samedi",
      "Sunday": "Dimanche",
      "TODAY'S STATES": "LES ÉTATS D'AUJOURD'HUI",
      "AVERAGE THIS WEEK": "MOYENNE CETTE SEMAINE",
      "Category": "Catégorie",
      "Total Usage": "Utilisation totale",
      "Search by application": "Recherche par application",
      "Usage Percentage": "Pourcentage d'utilisation",
      "Used For": "Utilisé pour",
      "Usage Limit": "Limite d'utilisation",
      "Hour": "Heure",
      "Hours": "Heures",
      "Min": "Min",
      "Cancel": "Annuler",
      "5 min before the usage limit reaches":"5 min avant que la limite d'utilisation n'atteigne",
      "If today's time on exceeded the average":"Si l'heure d'aujourd'hui dépassait la moyenne",
      "Notify me :":"Prévenez-moi :",
      "Submit": "Soumettre",
      "Notification Frequency": "Fréquence des notifications",
      'Once daily': 'Une fois par jour',
      'Twice daily': 'Deux fois par jour',
      '3 times a day': '3 fois par jour',
      '4 times a day': '4 fois par jour',
      '5 times a day': '5 fois par jour',
      "General": "Général",
      "Notifications": "Notifications",
      "Rate Us": "Évaluez nous",
      "About": "À propos",
      "Dark Theme": "Thème sombre",
      "FeedBack": "Retour d'information",
      "Report a bug": "Signaler un bug",
      "Send FeedBack": "Envoyer des commentaires",
      "Settings": "Paramètres",
      "Language": "Langue",
      "English": "Anglais",
      "French": "Français",
      "Spanish": "Espagnol",
      "German": "Allemand",
      "System": "Système",
      "Audio": "Audio",
      "Game": "Jeu",
      "Image": "Image",
      "Navigation": "Navigation",
      "News": "Actualités",
      "Productivity": "Productivité",
      "Social": "Social",
      "Video": "Video",
      "Unkown": "Inconnu",
      "Other": "Autre",
      "Delete": "Supprimer",
      "Delete Rule?":"Supprimer la règle?",
      'Are you sure you want to delete this rule?':"Êtes-vous sûr de vouloir supprimer cette règle ?",
      "per day": "par jour",
      "Yes":"Oui",
      "No":"Non",
      "Okay":"OK",
      'Deleted successfully':'Supprimé avec succès',
      'The rule was successfully deleted, click okay to continue.':'La règle a été supprimée avec succès, cliquez sur "OK" pour continuer.',
      "Report a bug \nOr Request a feature":
          "Signaler un bug \nOu demander une fonctionnalité",
      "Title": "Titre",
      "please enter a valid Title": "veuillez entrer un titre valide",
      "Description": "Description",
      "please enter a valid Description":
          "veuillez entrer une description valide",
      'Thank You!': 'Merci!',
      "Thank you for reporting the bug.\nIt is very helpful for us!":
          "Merci d'avoir signalé le bogue.\nC'est très utile pour nous !",
      "Sorry!": "Pardon!",
      "It seems like you have some internet problems.":
          "Il semble que vous ayez des problèmes avec Internet.",
      'Close': 'Fermer',
      "please enter a valid FeedBack": "Veuillez entrer un FeedBack valide",
      'Thank you for your feedBack.\nIt is very helpful for us!':
          'Merci pour votre retour.\nIl nous est très utile !',
      "Edit rule": "Modifier la règle",
      "Welcome to BreakIt Rules Functionality":
          "Bienvenue dans la fonctionnalité des règles de BreakIt",
      "In order to add a usage rule to any installed app, Simply click on the plus button and fill in with the desired usage limits, then click on 'submit'.":
          "Afin d'ajouter une règle d'utilisation à n'importe quelle application installée, cliquez simplement sur le bouton plus et remplissez les limites d'utilisation souhaitées, puis cliquez sur 'soumettre'.",
    },
    "Spanish": {
      "What is BreakIt?": "¿Qué es BreakIt?",
      "BreakIt is an Android application developed by \"Affes Achraf\" as an internship project supervised by \"WebGraphique\" it's an app that helps you improve your self control and time management.":
          "BreakIt es una aplicación para Android desarrollada por \"Affes Achraf \" como un proyecto de pasantía supervisado por \"WebGraphique \", es una aplicación que te ayuda a mejorar tu autocontrol y gestión del tiempo.",
      "Main functionalities of BreakIt?":
          "¿Principales funcionalidades de BreakIt?",
      "Through this app you can check your mobile phone usage statistics, top used apps, top used category, average usage etc ...\nThe app also includes details for each installed app, it also allows you to set down rules of usage for each application so that it notifies you when the time limit has exceeded.":
          "A través de esta aplicación, puede verificar las estadísticas de uso de su teléfono móvil, las aplicaciones más utilizadas, la categoría más utilizada, el uso promedio, etc. \ nLa aplicación también incluye detalles para cada aplicación instalada, también le permite establecer reglas de uso para cada aplicación para que te avise cuando se haya superado el límite de tiempo.",
      "Does it consume battery?": "¿Consume batería?",
      "Our app updates its data once every 15min in the background or immediately after entering the app and therefore the power consumption is very low.":
          "Nuestra aplicación actualiza sus datos una vez cada 15 minutos en segundo plano o inmediatamente después de ingresar a la aplicación y, por lo tanto, el consumo de energía es muy bajo.",
      "Usage Dashboard": "Panel de uso",
      "Activities": "Ocupaciones",
      "Rules": "Reglas",
      "New Rule": "Nueva regla",
      "Application": "Aplicación",
      "Monday": "lunes",
      "Tuesday": "Martes",
      "Wednesday": "Miércoles",
      "Thursday": "Jueves",
      "Friday": "Viernes",
      "Saturday": "Sábado",
      "Sunday": "Domingo",
      "TODAY'S STATES": "ESTADOS DE HOY",
      "AVERAGE THIS WEEK": "PROMEDIO ESTA SEMANA",
      "Category": "Categoría",
      "Total Usage": "Uso total",
      "Search by application": "Buscar por aplicación",
      "Usage Percentage": "Porcentaje de uso",
      "Used For": "Usado para",
      "Usage Limit": "Límite de uso",
      "Hour": "Hora",
      "Hours": "Horas",
      "Min": "Min",
      "5 min before the usage limit reaches":"5 minutos antes de que se alcance el límite de uso",
      "If today's time on exceeded the average":"Si la hora de hoy supera el promedio",
      "Notify me :":"Notificarme :",
      "Cancel": "Cancelar",
      "Submit": "someter",
      "Notification Frequency": "Frecuencia de notificación",
      'Once daily': 'Una vez al día',
      'Twice daily': 'dos veces al día',
      '3 times a day': '3 veces al día',
      '4 times a day': '4 veces al día',
      '5 times a day': '5 veces al día',
      "General": "Général",
      "Notifications": "Notificaciones",
      "Rate Us": "Nos califica",
      "About": "Acerca de",
      "Dark Theme": "Tema oscuro",
      "FeedBack": "Realimentación",
      "Report a bug": "Reportar un error",
      "Send FeedBack": "Enviar retroalimentación",
      "Settings": "Ajustes",
      "Language": "Lengua",
      "English": "Inglés",
      "French": "Francés",
      "Spanish": "Español",
      "German": "Alemán",
      "System": "Sistema",
      "Audio": "Audio",
      "Game": "Juego",
      "Image": "Imagen",
      "Navigation": "Navegación",
      "News": "Noticias",
      "Productivity": "Productividad",
      "Social": "Social",
      "Video": "Video",
      "Yes":"Sí",
      "Okay":"Aceptar",
      "No":"No",
      'Deleted successfully':'Eliminado con éxito',
      'The rule was successfully deleted, click okay to continue.':'La regla se eliminó correctamente, haga clic en "Aceptar" para continuar.',
      "Unkown": "Desconocido",
      "Other": "Otra",
      "Delete Rule?":"Eliminar regla",
      'Are you sure you want to delete this rule?':"¿Está seguro de que desea eliminar esta regla?",
      "Delete": "Borrar",
      "per day": "por día",
      "Report a bug \nOr Request a feature":
          "Informar un error \nO solicitar una función",
      "Title": "Título",
      "please enter a valid Title": "Introduzca un título válido",
      "Description": "Descripción",
      "please enter a valid Description":
          "por favor ingrese una descripción válida",
      'Thank You!': '¡Gracias!',
      "Thank you for reporting the bug.\nIt is very helpful for us!":
          "Gracias por informar del error. \n¡Es muy útil para nosotros!",
      "Sorry!": "¡Lo siento!",
      "It seems like you have some internet problems.":
          "Parece que tienes algunos problemas con Internet",
      'Close': 'Cerrar',
      "please enter a valid FeedBack":
          "Por favor ingrese una retroalimentación válida",
      'Thank you for your feedBack.\nIt is very helpful for us!':
          'Gracias por tu feedBack. \n¡Es muy útil para nosotros!',
      "Edit rule": "Editar regla",
      "Welcome to BreakIt Rules Functionality":
          "Bienvenido a la funcionalidad de reglas de BreakIt",
      "In order to add a usage rule to any installed app, Simply click on the plus button and fill in with the desired usage limits, then click on 'submit'.":
          "Para agregar una regla de uso a cualquier aplicación instalada, simplemente haga clic en el botón más y complete con los límites de uso deseados, luego haga clic en 'enviar'",
    },
    "German": {
      "What is BreakIt?": "Was ist BreakIt?",
      "BreakIt is an Android application developed by \"Affes Achraf\" as an internship project supervised by \"WebGraphique\" it's an app that helps you improve your self control and time management.":
          "BreakIt ist eine Android-Anwendung, die von \"Affes Achraf\" als Praktikumsprojekt entwickelt wurde und von \"WebGraphique\" betreut wird. Es ist eine App, die Ihnen hilft, Ihre Selbstkontrolle und Ihr Zeitmanagement zu verbessern.",
      "Main functionalities of BreakIt?": "Hauptfunktionen von BreakIt?",
      "Through this app you can check your mobile phone usage statistics, top used apps, top used category, average usage etc ...\nThe app also includes details for each installed app, it also allows you to set down rules of usage for each application so that it notifies you when the time limit has exceeded.":
          "Mit dieser App können Sie Ihre Handy-Nutzungsstatistiken, die am häufigsten verwendeten Apps, die am häufigsten verwendete Kategorie, die durchschnittliche Nutzung usw. überprüfen.\nDie App enthält auch Details zu jeder installierten App und ermöglicht es Ihnen auch, Nutzungsregeln für jede Anwendung festzulegen damit es Sie benachrichtigt, wenn die Frist überschritten ist.",
      "Does it consume battery?": "Verbraucht es Batterie?",
      "Our app updates its data once every 15 min in the background or immediately after entering the app and therefore the power consumption is very low.":
          "Unsere App aktualisiert ihre Daten alle 15 min im Hintergrund oder direkt nach dem Aufrufen der App und somit ist der Stromverbrauch sehr gering.",
      "Usage Dashboard": "Nutzungs-Dashboard",
      "Activities": "Aktivitäten",
      "Rules": "Regeln",
      "New Rule": "Neue Regel",
      "Application": "Anwendung",
      "Monday": "Montag",
      "Tuesday": "Dienstag",
      "Wednesday": "Mittwoch",
      "Thursday": "Donnerstag",
      "Friday": "Freitag",
      "Saturday": "Samstag",
      "Sunday": "Sonntag",
      "TODAY'S STATES": "DIE STAATEN VON HEUTE",
      "AVERAGE THIS WEEK": "DURCHSCHNITT DIESE WOCHE",
      "Category": "Kategorie",
      "Total Usage": "Gesamtnutzung",
      "Search by application": "Suche nach Anwendung",
      "Usage Percentage": "Nutzungsprozentsatz",
      "Used For": "Benutzt für",
      "Usage Limit": "Nutzungsbeschränkung",
      "Hour": "Stunde",
      "Hours": "Std",
      "Min": "Min",
      "Cancel": "Stornieren",
      "5 min before the usage limit reaches":"5 min bevor das Nutzungslimit erreicht ist",
      "If today's time on exceeded the average":"Wenn die heutige Zeit über dem Durchschnitt liegt",
      "Notify me :":"Benachrichtige mich :",
      "Submit": "Einreichen",
      "Notification Frequency": "Benachrichtigungshäufigkeit",
      'Once daily': 'Einmal täglich',
      'Twice daily': 'Zweimal täglich',
      '3 times a day': '3 mal täglich',
      '4 times a day': '4 mal täglich',
      '5 times a day': '5 mal täglich',
      "General": "Allgemein",
      "Notifications": "Benachrichtigungen",
      "Rate Us": "Bewerten Sie uns",
      "About": "Über",
      "Dark Theme": "Dunkles Thema",
      "FeedBack": "FeedBack",
      "Report a bug": "Melde einen technischen Fehler",
      "Send FeedBack": "Feedback schicken",
      "Settings": "Einstellungen",
      "Language": "Sprache",
      "English": "Englisch",
      "French": "Französisch",
      "Spanish": "Spanisch",
      "German": "Deutsche",
      "System": "Sistema",
      "Audio": "Audio",
      "Game": "Spiel",
      "Okay":"Ok",
      "Yes":"Jawohl",
      "No":"Nein",
      'Deleted successfully':'Erfolgreich gelöscht',
      'The rule was successfully deleted, click okay to continue.':"Die Regel wurde erfolgreich gelöscht. Klicken Sie auf 'OK', um fortzufahren.",
      "Image": "Image",
      "Navigation": "Navigation",
      "News": "Nachrichten",
      "Productivity": "Produktivität",
      "Social": "Sozial",
      "Video": "Video",
      "Unkown": "Unbekannt",
      "Other": "Sonstiges",
      "Delete": "Löschen",
      "Delete Rule?":"Regel löschen",
      'Are you sure you want to delete this rule?':'Möchten Sie diese Regel wirklich löschen?',
      "per day": "pro Tag",
      "Report a bug \nOr Request a feature":
          "Fehler melden \nOder Feature anfordern",
      "Title": "Titel",
      "please enter a valid Title": "Bitte geben Sie einen gültigen Titel ein",
      "Description": "Beschreibung",
      "please enter a valid Description":
          "Bitte geben Sie eine gültige Beschreibung ein",
      'Thank You!': 'Danke dir!',
      "Thank you for reporting the bug.\nIt is very helpful for us!":
          "Danke, dass Sie den Fehler gemeldet haben.\nEs ist sehr hilfreich für uns!",
      "Sorry!": "Verzeihung!",
      "It seems like you have some internet problems.":
          "Anscheinend haben Sie Internetprobleme.",
      'Close': 'Schließen',
      "please enter a valid FeedBack":
          "Bitte geben Sie ein gültiges Feedback ein",
      'Thank you for your feedBack.\nIt is very helpful for us!':
          'Vielen Dank für Ihr Feedback.\nEs ist sehr hilfreich für uns!',
      "Edit rule": "Regel bearbeiten",
      "Welcome to BreakIt Rules Functionality":
          "Willkommen bei der Rules-Funktionalität von BreakIt",
      "In order to add a usage rule to any installed app, Simply click on the plus button and fill in with the desired usage limits, then click on 'submit'.":
          "Um einer installierten App eine Nutzungsregel hinzuzufügen, klicken Sie einfach auf den Plus-Button und geben Sie die gewünschten Nutzungslimits ein und klicken Sie dann auf 'Senden'.",
    }
  };

  static final SharedData _sharedData = new SharedData._internal();
  bool permessionGranted = false;
  int totalUsage = 0;
  int totalUsageWithoutSystem = 0;
  List<AppUsageInfo> applications = [];

  Future getAppList() async {
    applications = [];
    applications.addAll(await SharedData().getUsageStats(
        DateTime.now().subtract(Duration(days: 1)), DateTime.now(), false));
    applications.sort((a, b) => a.usage.compareTo(b.usage));
  }

  factory SharedData() {
    return _sharedData;
  }
  SharedData._internal();

  String? getCategory(
      ApplicationCategory appCategory, bool isSysApp, bool forDataBase) {
    if (!forDataBase) {
      if (isSysApp) {
        return SharedData().dictionary[Shared.selectedLanguage]?["System"];
      }
      switch (appCategory) {
        case ApplicationCategory.audio:
          return SharedData().dictionary[Shared.selectedLanguage]?["Audio"];
        case ApplicationCategory.game:
          return SharedData().dictionary[Shared.selectedLanguage]?["Game"];
        case ApplicationCategory.image:
          return SharedData().dictionary[Shared.selectedLanguage]?["Image"];
        case ApplicationCategory.maps:
          return SharedData().dictionary[Shared.selectedLanguage]
              ?["Navigation"];
        case ApplicationCategory.news:
          return SharedData().dictionary[Shared.selectedLanguage]?["News"];
        case ApplicationCategory.productivity:
          return SharedData().dictionary[Shared.selectedLanguage]
              ?["Productivity"];
        case ApplicationCategory.social:
          return SharedData().dictionary[Shared.selectedLanguage]?["Social"];
        case ApplicationCategory.video:
          return SharedData().dictionary[Shared.selectedLanguage]?["Video"];
        default:
          return SharedData().dictionary[Shared.selectedLanguage]?["Unkown"];
      }
    }
    if (isSysApp) {
      return "System";
    }
    switch (appCategory) {
      case ApplicationCategory.audio:
        return "Audio";
      case ApplicationCategory.game:
        return "Game";
      case ApplicationCategory.image:
        return "Image";
      case ApplicationCategory.maps:
        return "Navigation";
      case ApplicationCategory.news:
        return "News";
      case ApplicationCategory.productivity:
        return "Productivity";
      case ApplicationCategory.social:
        return "Social";
      case ApplicationCategory.video:
        return "Video";
      default:
        return "Unkown";
    }
  }

  Future<Application?> getIcon(String packageName) async {
    Future<Application?> app = DeviceApps.getApp(packageName, true);
    return app;
  }

  Future<List<AppUsageInfo>> getUsageStats(
      DateTime startDate, DateTime endDate, bool updateTotalUsage) async {
    int totalUsageLocal = 0;
    int totalUsageWithoutSystemLocal = 0;
    try {
      List<AppUsageInfo> infos = await AppUsage.getAppUsage(startDate, endDate);
      infos.sort((a, b) => a.usage.compareTo(b.usage));
      if (updateTotalUsage) {
        for (var app in infos) {
          Application? moreDetails = await DeviceApps.getApp(app.packageName);
          if (moreDetails != null) {
            if (!moreDetails.systemApp) {
              totalUsageWithoutSystemLocal += app.usage.inMinutes;
            }
          }
          totalUsageLocal += app.usage.inMinutes;
        }
        totalUsage = totalUsageLocal;
        totalUsageWithoutSystem = totalUsageWithoutSystemLocal;
      }
      return infos;
    } on AppUsageException catch (exception) {
      print(exception);
      return [];
    }
  }

  List<AppUsageInfo> yesterdaysDataUsage = [];
  Future<List<AppDailyInfo>> getDailyUsageStats(DateTime day) async {
    List<AppDailyInfo>? result = await DataBase.instance.readAppDailyInfo(day);
    if (result != null) {
      Generaldata? lastCheck = await DataBase.instance.getGeneralData("LastCheckActivities");
      if (lastCheck != null) {
        if (DateTime.now()
            .subtract(Duration(minutes: 5))
            .isAfter(DateTime.parse(lastCheck.data))) {
          await DataBase.instance.deleteTodaysAppDailyInfo();
          await DataBase.instance.updateLastCheckActivities();
          return createDailyUsageState(day);
        }
      }
      return result;
    } else {
      yesterdaysDataUsage =
          await getUsageStats(day.subtract(Duration(days: 1)), day, false);
      return createDailyUsageState(day);
    }
  }

  Future<List<AppDailyInfo>> createDailyUsageState(DateTime day) async {
    int totalUsageLocal = 0;
    List<AppDailyInfo> result = [];
    try {
      List<AppUsageInfo> infos =
          await AppUsage.getAppUsage(day, day.add(Duration(days: 1)));
      infos.sort((a, b) => a.usage.compareTo(b.usage));
      for (var app in infos) {
        Application? moreDetails = await DeviceApps.getApp(app.packageName);
        totalUsageLocal += app.usage.inMinutes;
      }
      for (var app in infos) {
        Application? moreDetails = await DeviceApps.getApp(app.packageName);
        int yesterdaysUsage = yesterdaysDataUsage
            .firstWhere(
                (element) => (element.appName == app.appName &&
                    element.packageName == app.packageName),
                orElse: () =>
                    AppUsageInfo("empty", 0, DateTime.now(), DateTime.now()))
            .usage
            .inMinutes;
        int todaysUsage = app.usage.inMinutes;
        if (moreDetails != null) {
          AppDailyInfo appDailyInfo = AppDailyInfo(
              appName: moreDetails.appName,
              appPackageName: app.packageName,
              category: getCategory(
                      moreDetails.category, moreDetails.systemApp, true) ??
                  "Unkown",
              usageInMin: app.usage.inMinutes,
              date: day.year.toString() +
                  day.month.toString() +
                  day.day.toString(),
              comparisonPerc: (yesterdaysUsage != 0 && todaysUsage != 0)
                  ? (((todaysUsage - yesterdaysUsage) / yesterdaysUsage) * 100)
                      .round()
                  : 0,
              usagePerc: double.parse(
                  ((app.usage.inMinutes / totalUsageLocal) * 100)
                      .toStringAsFixed(2)));
          DataBase.instance.createAppDailyInfo(appDailyInfo);
          result.add(appDailyInfo);
        } else {
          AppDailyInfo appDailyInfo = AppDailyInfo(
              appName: app.appName,
              appPackageName: app.packageName,
              category:
                  dictionary[Shared.selectedLanguage]?["Unkown"] ?? "Unkown",
              usageInMin: app.usage.inMinutes,
              date: day.year.toString() +
                  day.month.toString() +
                  day.day.toString(),
              comparisonPerc: (yesterdaysUsage != 0 && todaysUsage != 0)
                  ? (((todaysUsage - yesterdaysUsage) / yesterdaysUsage) * 100)
                      .round()
                  : 0,
              usagePerc: double.parse(
                  ((app.usage.inMinutes / totalUsageLocal) * 100)
                      .toStringAsFixed(2)));
          DataBase.instance.createAppDailyInfo(appDailyInfo);
          result.add(appDailyInfo);
        }
      }
      return result;
    } catch (exception) {
      print(exception);
      return [];
    }
  }
}
