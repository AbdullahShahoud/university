import 'dart:async';
import 'package:flutter/material.dart';
import 'en_us.dart';
import 'ar_sy.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Common
  String get appName =>
      _localizedValues[locale.languageCode]?['appName'] ?? EnUs.appName;
  String get ok => _localizedValues[locale.languageCode]?['ok'] ?? EnUs.ok;
  String get cancel =>
      _localizedValues[locale.languageCode]?['cancel'] ?? EnUs.cancel;
  String get save =>
      _localizedValues[locale.languageCode]?['save'] ?? EnUs.save;
  String get delete =>
      _localizedValues[locale.languageCode]?['delete'] ?? EnUs.delete;
  String get edit =>
      _localizedValues[locale.languageCode]?['edit'] ?? EnUs.edit;
  String get loading =>
      _localizedValues[locale.languageCode]?['loading'] ?? EnUs.loading;
  String get error =>
      _localizedValues[locale.languageCode]?['error'] ?? EnUs.error;
  String get retry =>
      _localizedValues[locale.languageCode]?['retry'] ?? EnUs.retry;
  String get noData =>
      _localizedValues[locale.languageCode]?['noData'] ?? EnUs.noData;
  String get search =>
      _localizedValues[locale.languageCode]?['search'] ?? EnUs.search;

  // Navigation
  String get explore =>
      _localizedValues[locale.languageCode]?['explore'] ?? EnUs.explore;
  String get favorites =>
      _localizedValues[locale.languageCode]?['favorites'] ?? EnUs.favorites;
  String get followings =>
      _localizedValues[locale.languageCode]?['followings'] ?? EnUs.followings;
  String get notifications =>
      _localizedValues[locale.languageCode]?['notifications'] ??
      EnUs.notifications;
  String get profile =>
      _localizedValues[locale.languageCode]?['profile'] ?? EnUs.profile;
  String get news =>
      _localizedValues[locale.languageCode]?['news'] ?? EnUs.news;

  // Explore
  String get exploreTitle =>
      _localizedValues[locale.languageCode]?['exploreTitle'] ??
      EnUs.exploreTitle;
  String get searchHint =>
      _localizedValues[locale.languageCode]?['searchHint'] ?? EnUs.searchHint;
  String get featuredCompanies =>
      _localizedValues[locale.languageCode]?['featuredCompanies'] ??
      EnUs.featuredCompanies;
  String get latest =>
      _localizedValues[locale.languageCode]?['latest'] ?? EnUs.latest;
  String get technology =>
      _localizedValues[locale.languageCode]?['technology'] ?? EnUs.technology;
  String get commerce =>
      _localizedValues[locale.languageCode]?['commerce'] ?? EnUs.commerce;
  String get services =>
      _localizedValues[locale.languageCode]?['services'] ?? EnUs.services;

  // Startup Profile
  String get about =>
      _localizedValues[locale.languageCode]?['about'] ?? EnUs.about;
  String get features =>
      _localizedValues[locale.languageCode]?['features'] ?? EnUs.features;
  String get contact =>
      _localizedValues[locale.languageCode]?['contact'] ?? EnUs.contact;
  String get follow =>
      _localizedValues[locale.languageCode]?['follow'] ?? EnUs.follow;
  String get following =>
      _localizedValues[locale.languageCode]?['following'] ?? EnUs.following;
  String get website =>
      _localizedValues[locale.languageCode]?['website'] ?? EnUs.website;
  String get founder =>
      _localizedValues[locale.languageCode]?['founder'] ?? EnUs.founder;
  String get location =>
      _localizedValues[locale.languageCode]?['location'] ?? EnUs.location;
  String get rating =>
      _localizedValues[locale.languageCode]?['rating'] ?? EnUs.rating;
  String get reviews =>
      _localizedValues[locale.languageCode]?['reviews'] ?? EnUs.reviews;
  String get mainFeatures =>
      _localizedValues[locale.languageCode]?['mainFeatures'] ??
      EnUs.mainFeatures;
  String get companyNews =>
      _localizedValues[locale.languageCode]?['companyNews'] ?? EnUs.companyNews;
  String get searchInNews =>
      _localizedValues[locale.languageCode]?['searchInNews'] ??
      EnUs.searchInNews;
  String get contactCompany =>
      _localizedValues[locale.languageCode]?['contactCompany'] ??
      EnUs.contactCompany;
  String get contactViaWhatsapp =>
      _localizedValues[locale.languageCode]?['contactViaWhatsapp'] ??
      EnUs.contactViaWhatsapp;
  String get callDirectly =>
      _localizedValues[locale.languageCode]?['callDirectly'] ??
      EnUs.callDirectly;
  String get visitWebsite =>
      _localizedValues[locale.languageCode]?['visitWebsite'] ??
      EnUs.visitWebsite;
  String get name =>
      _localizedValues[locale.languageCode]?['name'] ?? EnUs.name;
  String get email =>
      _localizedValues[locale.languageCode]?['email'] ?? EnUs.email;
  String get message =>
      _localizedValues[locale.languageCode]?['message'] ?? EnUs.message;
  String get sendMessage =>
      _localizedValues[locale.languageCode]?['sendMessage'] ?? EnUs.sendMessage;
  String get founded =>
      _localizedValues[locale.languageCode]?['founded'] ?? EnUs.founded;
  String get phone =>
      _localizedValues[locale.languageCode]?['phone'] ?? EnUs.phone;

  // News
  String get newsTitle =>
      _localizedValues[locale.languageCode]?['newsTitle'] ?? EnUs.newsTitle;
  String get readTime =>
      _localizedValues[locale.languageCode]?['readTime'] ?? EnUs.readTime;
  String get comments =>
      _localizedValues[locale.languageCode]?['comments'] ?? EnUs.comments;
  String get addComment =>
      _localizedValues[locale.languageCode]?['addComment'] ?? EnUs.addComment;
  String get like =>
      _localizedValues[locale.languageCode]?['like'] ?? EnUs.like;
  String get share =>
      _localizedValues[locale.languageCode]?['share'] ?? EnUs.share;
  String get saveArticle =>
      _localizedValues[locale.languageCode]?['saveArticle'] ?? EnUs.saveArticle;

  // Favorites
  String get favoritesTitle =>
      _localizedValues[locale.languageCode]?['favoritesTitle'] ??
      EnUs.favoritesTitle;
  String get noFavorites =>
      _localizedValues[locale.languageCode]?['noFavorites'] ?? EnUs.noFavorites;

  // Notifications
  String get notificationsTitle =>
      _localizedValues[locale.languageCode]?['notificationsTitle'] ??
      EnUs.notificationsTitle;
  String get noNotifications =>
      _localizedValues[locale.languageCode]?['noNotifications'] ??
      EnUs.noNotifications;

  // Profile
  String get myAccount =>
      _localizedValues[locale.languageCode]?['myAccount'] ?? EnUs.myAccount;
  String get favoriteCompanies =>
      _localizedValues[locale.languageCode]?['favoriteCompanies'] ??
      EnUs.favoriteCompanies;
  String get appSettings =>
      _localizedValues[locale.languageCode]?['appSettings'] ?? EnUs.appSettings;
  String get helpAndSupport =>
      _localizedValues[locale.languageCode]?['helpAndSupport'] ??
      EnUs.helpAndSupport;
  String get privacyAndTerms =>
      _localizedValues[locale.languageCode]?['privacyAndTerms'] ??
      EnUs.privacyAndTerms;
  String get logout =>
      _localizedValues[locale.languageCode]?['logout'] ?? EnUs.logout;
  String get language =>
      _localizedValues[locale.languageCode]?['language'] ?? EnUs.language;
  String get theme =>
      _localizedValues[locale.languageCode]?['theme'] ?? EnUs.theme;
  String get lightMode =>
      _localizedValues[locale.languageCode]?['lightMode'] ?? EnUs.lightMode;
  String get darkMode =>
      _localizedValues[locale.languageCode]?['darkMode'] ?? EnUs.darkMode;
  String get english =>
      _localizedValues[locale.languageCode]?['english'] ?? EnUs.english;
  String get arabic =>
      _localizedValues[locale.languageCode]?['arabic'] ?? EnUs.arabic;

  // Error messages
  String get networkError =>
      _localizedValues[locale.languageCode]?['networkError'] ??
      EnUs.networkError;
  String get serverError =>
      _localizedValues[locale.languageCode]?['serverError'] ?? EnUs.serverError;
  String get unknownError =>
      _localizedValues[locale.languageCode]?['unknownError'] ??
      EnUs.unknownError;
  String get validationError =>
      _localizedValues[locale.languageCode]?['validationError'] ??
      EnUs.validationError;

  // Success messages
  String get success =>
      _localizedValues[locale.languageCode]?['success'] ?? EnUs.success;
  String get messageSent =>
      _localizedValues[locale.languageCode]?['messageSent'] ?? EnUs.messageSent;
  String get followed =>
      _localizedValues[locale.languageCode]?['followed'] ?? EnUs.followed;
  String get unfollowed =>
      _localizedValues[locale.languageCode]?['unfollowed'] ?? EnUs.unfollowed;

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Common
      'appName': EnUs.appName,
      'ok': EnUs.ok,
      'cancel': EnUs.cancel,
      'save': EnUs.save,
      'delete': EnUs.delete,
      'edit': EnUs.edit,
      'loading': EnUs.loading,
      'error': EnUs.error,
      'retry': EnUs.retry,
      'noData': EnUs.noData,
      'search': EnUs.search,

      // Navigation
      'explore': EnUs.explore,
      'favorites': EnUs.favorites,
      'notifications': EnUs.notifications,
      'profile': EnUs.profile,
      'news': EnUs.news,

      // Explore
      'exploreTitle': EnUs.exploreTitle,
      'searchHint': EnUs.searchHint,
      'featuredCompanies': EnUs.featuredCompanies,
      'latest': EnUs.latest,
      'technology': EnUs.technology,
      'commerce': EnUs.commerce,
      'services': EnUs.services,

      // Startup Profile
      'about': EnUs.about,
      'features': EnUs.features,
      'contact': EnUs.contact,
      'follow': EnUs.follow,
      'following': EnUs.following,
      'website': EnUs.website,
      'founder': EnUs.founder,
      'location': EnUs.location,
      'rating': EnUs.rating,
      'reviews': EnUs.reviews,
      'mainFeatures': EnUs.mainFeatures,
      'companyNews': EnUs.companyNews,
      'searchInNews': EnUs.searchInNews,
      'contactCompany': EnUs.contactCompany,
      'contactViaWhatsapp': EnUs.contactViaWhatsapp,
      'callDirectly': EnUs.callDirectly,
      'visitWebsite': EnUs.visitWebsite,
      'name': EnUs.name,
      'email': EnUs.email,
      'message': EnUs.message,
      'sendMessage': EnUs.sendMessage,
      'founded': EnUs.founded,
      'phone': EnUs.phone,

      // News
      'newsTitle': EnUs.newsTitle,
      'readTime': EnUs.readTime,
      'comments': EnUs.comments,
      'addComment': EnUs.addComment,
      'like': EnUs.like,
      'share': EnUs.share,
      'saveArticle': EnUs.saveArticle,

      // Favorites
      'favoritesTitle': EnUs.favoritesTitle,
      'noFavorites': EnUs.noFavorites,

      // Notifications
      'notificationsTitle': EnUs.notificationsTitle,
      'noNotifications': EnUs.noNotifications,

      // Profile
      'myAccount': EnUs.myAccount,
      'favoriteCompanies': EnUs.favoriteCompanies,
      'appSettings': EnUs.appSettings,
      'helpAndSupport': EnUs.helpAndSupport,
      'privacyAndTerms': EnUs.privacyAndTerms,
      'logout': EnUs.logout,
      'language': EnUs.language,
      'theme': EnUs.theme,
      'lightMode': EnUs.lightMode,
      'darkMode': EnUs.darkMode,
      'english': EnUs.english,
      'arabic': EnUs.arabic,

      // Error messages
      'networkError': EnUs.networkError,
      'serverError': EnUs.serverError,
      'unknownError': EnUs.unknownError,
      'validationError': EnUs.validationError,

      // Success messages
      'success': EnUs.success,
      'messageSent': EnUs.messageSent,
      'followed': EnUs.followed,
      'unfollowed': EnUs.unfollowed,
    },
    'ar': {
      // Common
      'appName': ArSy.appName,
      'ok': ArSy.ok,
      'cancel': ArSy.cancel,
      'save': ArSy.save,
      'delete': ArSy.delete,
      'edit': ArSy.edit,
      'loading': ArSy.loading,
      'error': ArSy.error,
      'retry': ArSy.retry,
      'noData': ArSy.noData,
      'search': ArSy.search,

      // Navigation
      'explore': ArSy.explore,
      'favorites': ArSy.favorites,
      'notifications': ArSy.notifications,
      'profile': ArSy.profile,
      'news': ArSy.news,

      // Explore
      'exploreTitle': ArSy.exploreTitle,
      'searchHint': ArSy.searchHint,
      'featuredCompanies': ArSy.featuredCompanies,
      'latest': ArSy.latest,
      'technology': ArSy.technology,
      'commerce': ArSy.commerce,
      'services': ArSy.services,

      // Startup Profile
      'about': ArSy.about,
      'features': ArSy.features,
      'contact': ArSy.contact,
      'follow': ArSy.follow,
      'following': ArSy.following,
      'website': ArSy.website,
      'founder': ArSy.founder,
      'location': ArSy.location,
      'rating': ArSy.rating,
      'reviews': ArSy.reviews,
      'mainFeatures': ArSy.mainFeatures,
      'companyNews': ArSy.companyNews,
      'searchInNews': ArSy.searchInNews,
      'contactCompany': ArSy.contactCompany,
      'contactViaWhatsapp': ArSy.contactViaWhatsapp,
      'callDirectly': ArSy.callDirectly,
      'visitWebsite': ArSy.visitWebsite,
      'name': ArSy.name,
      'email': ArSy.email,
      'message': ArSy.message,
      'sendMessage': ArSy.sendMessage,
      'founded': ArSy.founded,
      'phone': ArSy.phone,

      // News
      'newsTitle': ArSy.newsTitle,
      'readTime': ArSy.readTime,
      'comments': ArSy.comments,
      'addComment': ArSy.addComment,
      'like': ArSy.like,
      'share': ArSy.share,
      'saveArticle': ArSy.saveArticle,

      // Favorites
      'favoritesTitle': ArSy.favoritesTitle,
      'noFavorites': ArSy.noFavorites,

      // Notifications
      'notificationsTitle': ArSy.notificationsTitle,
      'noNotifications': ArSy.noNotifications,

      // Profile
      'myAccount': ArSy.myAccount,
      'favoriteCompanies': ArSy.favoriteCompanies,
      'appSettings': ArSy.appSettings,
      'helpAndSupport': ArSy.helpAndSupport,
      'privacyAndTerms': ArSy.privacyAndTerms,
      'logout': ArSy.logout,
      'language': ArSy.language,
      'theme': ArSy.theme,
      'lightMode': ArSy.lightMode,
      'darkMode': ArSy.darkMode,
      'english': ArSy.english,
      'arabic': ArSy.arabic,

      // Error messages
      'networkError': ArSy.networkError,
      'serverError': ArSy.serverError,
      'unknownError': ArSy.unknownError,
      'validationError': ArSy.validationError,

      // Success messages
      'success': ArSy.success,
      'messageSent': ArSy.messageSent,
      'followed': ArSy.followed,
      'unfollowed': ArSy.unfollowed,
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
