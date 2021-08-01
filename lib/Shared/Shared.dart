import 'package:app_usage/app_usage.dart';
import 'package:break_it/Models/Appdaily.dart';
import 'package:break_it/Models/generalData.dart';
import 'package:break_it/Shared/database.dart';
import 'package:device_apps/device_apps.dart';

class Shared {
  //Colors
  static const int color_primary1 = 0xFF430064;
  static const int color_secondary1 = 0xFF9E00EC;
  static const int color_primary2 = 0xFFF6F5F6;
  static const int color_secondary2 = 0xFF655C98;

  static const int pieChartColor_yellow = 0xFF58508d;
  static const int pieChartColor_violet = 0xFFbc5090;
  static const int pieChartColor_blue = 0xFFff6361;
  static const int pieChartColor_red = 0xFFffa600;
  static const int pieChartColor_green = 0xFF34ad1d;

  static String selectedLanguage = "English";

  //Sentences

}

class SharedData {

  Map<String,Map<String,String>> dictionary = {
    "English" : {
      "Usage Dashboard" : "Usage Dashboard",
      "Activities" : "Activities",
      "Rules" : "Rules",
      "New Rule" : "New Rule",
      "Application" : "Application",
      "Monday" : "Monday",
      "Tuesday" : "Tuesday",
      "Wednesday" : "Wednesday",
      "Thursday" : "Thursday",
      "Friday" : "Friday",
      "Saturday" : "Saturday",
      "Sunday" : "Sunday",
      "TODAY'S STATES" : "TODAY'S STATES",
      "AVERAGE THIS WEEK" : "AVERAGE THIS WEEK",
      "Category" : "Category",
      "Total Usage" : "Total Usage",
      "Search by application" : "Search by application",
      "Usage Percentage" : "Usage Percentage",
      "Used For" :  "Used For",
      "Usage Limit" :  "Usage Limit",
      "Hour" :  "Hour",
      "Hours" :  "Hours",
      "Min" :  "Min",
      "Cancel" :  "Cancel",
      "Submit" :  "Submit",
      "Notification Frequency" : "Notification Frequency",
      'Once daily' : 'Once daily',
      'Twice daily' : 'Twice daily',
      '3 times a day' : '3 times a day',
      '4 times a day' : '4 times a day',
      '5 times a day' : '5 times a day',
      "General" : "General",
      "Notifications" : "Notifications",
      "Rate Us" : "Rate Us",
      "About" : "About",
      "Dark Theme" : "Dark Theme",
      "FeedBack" : "FeedBack",
      "Report a bug" : "Report a bug",
      "Send FeedBack" : "Send FeedBack",
      "Settings" : "Settings",
      "Language" : "Language",
      "English" : "English",
      "French" : "French",
      "Spanish" : "Spanish",
      "German" : "German",
      "System" : "System",
      "Audio" : "Audio",
      "Game" : "Game",
      "Image" : "Image",
      "Navigation" : "Navigation",
      "News" : "News",
      "Productivity" : "Productivity",
      "Social" : "Social",
      "Video" : "Video",
      "Unkown" : "Unkown",
      "Other" : "Other"
    },
    "French" : {
      "Usage Dashboard" : "Tableau de bord d'utilisation",
      "Activities" : "Activités",
      "Rules" : "Règles",
      "New Rule" : "Nouvelle règle",
      "Application" : "Application",
      "Monday" : "Lundi",
      "Tuesday" : "Mardi",
      "Wednesday" : "Mercredi",
      "Thursday" : "Jeudi",
      "Friday" : "Vendredi",
      "Saturday" : "Samedi",
      "Sunday" : "Dimanche",
      "TODAY'S STATES" : "LES ÉTATS D'AUJOURD'HUI",
      "AVERAGE THIS WEEK" : "MOYENNE CETTE SEMAINE",
      "Category" : "Catégorie",
      "Total Usage" : "Utilisation totale",
      "Search by application" : "Recherche par application",
      "Usage Percentage" : "Pourcentage d'utilisation",
      "Used For" :  "Utilisé pour",
      "Usage Limit" :  "Limite d'utilisation",
      "Hour" :  "Heure",
      "Hours" :  "Heures",
      "Min" :  "Min",
      "Cancel" :  "Annuler",
      "Submit" :  "Soumettre",
      "Notification Frequency" : "Fréquence des notifications",
      'Once daily' : 'Une fois par jour',
      'Twice daily' : 'Deux fois par jour',
      '3 times a day' : '3 fois par jour',
      '4 times a day' : '4 fois par jour',
      '5 times a day' : '5 fois par jour',
      "General" : "Général",
      "Notifications" : "Notifications",
      "Rate Us" : "Évaluez nous",
      "About" : "À propos",
      "Dark Theme" : "Thème sombre",
      "FeedBack" : "Retour d'information",
      "Report a bug" : "Signaler un bug",
      "Send FeedBack" : "Envoyer des commentaires",
      "Settings" : "Paramètres",
      "Language" : "Langue",
      "English" : "Anglais",
      "French" : "Français",
      "Spanish" : "Espagnol",
      "German" : "Allemand",
      "System" : "Système",
      "Audio" : "Audio",
      "Game" : "Jeu",
      "Image" : "Image",
      "Navigation" : "Navigation",
      "News" : "Actualités",
      "Productivity" : "Productivité",
      "Social" : "Social",
      "Video" : "Video",
      "Unkown" : "Inconnu",
      "Other" : "Autre"
    },
    "Spanish" : {
      "Usage Dashboard" : "Panel de uso",
      "Activities" : "Ocupaciones",
      "Rules" : "Reglas",
      "New Rule" : "Nueva regla",
      "Application" : "Aplicación",
      "Monday" : "lunes",
      "Tuesday" : "Martes",
      "Wednesday" : "Miércoles",
      "Thursday" : "Jueves",
      "Friday" : "Viernes",
      "Saturday" : "Sábado",
      "Sunday" : "Domingo",
      "TODAY'S STATES" : "ESTADOS DE HOY",
      "AVERAGE THIS WEEK" : "PROMEDIO ESTA SEMANA",
      "Category" : "Categoría",
      "Total Usage" : "Uso total",
      "Search by application" : "Buscar por aplicación",
      "Usage Percentage" : "Porcentaje de uso",
      "Used For" :  "Usado para",
      "Usage Limit" :  "Límite de uso",
      "Hour" :  "Hora",
      "Hours" :  "Horas",
      "Min" :  "Min",
      "Cancel" :  "Cancelar",
      "Submit" :  "someter",
      "Notification Frequency" : "Frecuencia de notificación",
      'Once daily' : 'Una vez al día',
      'Twice daily' : 'dos veces al día',
      '3 times a day' : '3 veces al día',
      '4 times a day' : '4 veces al día',
      '5 times a day' : '5 veces al día',
      "General" : "Général",
      "Notifications" : "Notificaciones",
      "Rate Us" : "Nos califica",
      "About" : "Acerca de",
      "Dark Theme" : "Tema oscuro",
      "FeedBack" : "Realimentación",
      "Report a bug" : "Reportar un error",
      "Send FeedBack" : "Enviar retroalimentación",
      "Settings" : "Ajustes",
      "Language" : "Lengua",
      "English" : "Inglés",
      "French" : "Francés",
      "Spanish" : "Español",
      "German" : "Alemán",
      "System" : "Sistema",
      "Audio" : "Audio",
      "Game" : "Juego",
      "Image" : "Imagen",
      "Navigation" : "Navegación",
      "News" : "Noticias",
      "Productivity" : "Productividad",
      "Social" : "Social",
      "Video" : "Video",
      "Unkown" : "Desconocido",
      "Other" : "Otra"
    },
    "German" : {
      "Usage Dashboard" : "Nutzungs-Dashboard",
      "Activities" : "Aktivitäten",
      "Rules" : "Regeln",
      "New Rule" : "Neue Regel",
      "Application" : "Anwendung",
      "Monday" : "Montag",
      "Tuesday" : "Dienstag",
      "Wednesday" : "Mittwoch",
      "Thursday" : "Donnerstag",
      "Friday" : "Freitag",
      "Saturday" : "Samstag",
      "Sunday" : "Sonntag",
      "TODAY'S STATES" : "DIE STAATEN VON HEUTE",
      "AVERAGE THIS WEEK" : "DURCHSCHNITT DIESE WOCHE",
      "Category" : "Kategorie",
      "Total Usage" : "Gesamtnutzung",
      "Search by application" : "Suche nach Anwendung",
      "Usage Percentage" : "Nutzungsprozentsatz",
      "Used For" :  "Benutzt für",
      "Usage Limit" :  "Nutzungsbeschränkung",
      "Hour" :  "Stunde",
      "Hours" :  "Std",
      "Min" :  "Min",
      "Cancel" :  "Stornieren",
      "Submit" :  "Einreichen",
      "Notification Frequency" : "Benachrichtigungshäufigkeit",
      'Once daily' : 'Einmal täglich',
      'Twice daily' : 'Zweimal täglich',
      '3 times a day' : '3 mal täglich',
      '4 times a day' : '4 mal täglich',
      '5 times a day' : '5 mal täglich',
      "General" : "Allgemein",
      "Notifications" : "Benachrichtigungen",
      "Rate Us" : "Bewerten Sie uns",
      "About" : "Über",
      "Dark Theme" : "Dunkles Thema",
      "FeedBack" : "Realimentación",
      "Report a bug" : "Melde einen technischen Fehler",
      "Send FeedBack" : "Feedback schicken",
      "Settings" : "Einstellungen",
      "Language" : "Sprache",
      "English" : "Englisch",
      "French" : "Französisch",
      "Spanish" : "Spanisch",
      "German" : "Deutsche",
      "System" : "Sistema",
      "Audio" : "Audio",
      "Game" : "Spiel",
      "Image" : "Image",
      "Navigation" : "Navigation",
      "News" : "Nachrichten",
      "Productivity" : "Produktivität",
      "Social" : "Sozial",
      "Video" : "Video",
      "Unkown" : "Unbekannt",
      "Other" : "Sonstiges"
    }
  };

  static final SharedData _sharedData = new SharedData._internal();
  bool permessionGranted = false;
  int totalUsage = 0;
  int totalUsageWithoutSystem = 0;
  List<AppUsageInfo> applications = [];

  Future getAppList() async {
    applications = [];
    applications.addAll(await SharedData().getUsageStats(DateTime.now().subtract(Duration(days: 1)),DateTime.now(),false));
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

  Future<List<AppDailyInfo>> getDailyUsageStats(
      DateTime day ) async {
    List<AppDailyInfo>? result = await DataBase.instance.readAppDailyInfo(day);
    if (result!=null){
      Generaldata? lastCheck = await DataBase.instance.getLastCheckActivities();
      if(lastCheck!=null){
        if(DateTime.now().subtract(Duration(minutes: 10)).isAfter(DateTime.parse(lastCheck.data))){
          await DataBase.instance.deleteTodaysAppDailyInfo();
          await DataBase.instance.updateLastCheckActivities();
          return createDailyUsageState(day);
        } 
      } 
      return result; 
    } else {
      return createDailyUsageState(day);
    }
  }

  Future <List<AppDailyInfo>> createDailyUsageState(DateTime day) async{
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
          if (moreDetails != null) {
            AppDailyInfo appDailyInfo = AppDailyInfo(
              appName: app.appName,
              appPackageName: app.packageName,
              category: getCategory(moreDetails.category, moreDetails.systemApp, true)??"Unkown",
              usageInMin: app.usage.inMinutes,
              date: day.year.toString()+day.month.toString()+day.day.toString(),
              comparisonPerc: 12,///MAKE IT DYNAMIC
              usagePerc: double.parse(((app.usage.inMinutes/totalUsageLocal)*100).toStringAsFixed(2))
            );
            DataBase.instance.createAppDailyInfo(appDailyInfo);
            result.add(appDailyInfo);
          } else{
            AppDailyInfo appDailyInfo = AppDailyInfo(
              appName: app.appName,
              appPackageName: app.packageName,
              category: dictionary[Shared.selectedLanguage]?["Unkown"]??"Unkown",
              usageInMin: app.usage.inMinutes,
              date: day.year.toString()+day.month.toString()+day.day.toString(),
              comparisonPerc: 12,///MAKE IT DYNAMIC
              usagePerc: double.parse(((app.usage.inMinutes/totalUsageLocal)*100).toStringAsFixed(2))
            );
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
