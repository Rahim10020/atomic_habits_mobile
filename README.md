# 🎯 Atomic Habits Tracker

Une application Flutter moderne pour créer et suivre vos habitudes basée sur les principes du livre "Atomic Habits" de James Clear.

## 📱 Fonctionnalités

### ✅ Implémenté
- ✨ **Création d'habitudes** avec les 4 lois du changement de comportement
- 📊 **Suivi quotidien** avec système de streak (chaîne de réussite)
- 📈 **Tableau de bord** avec statistiques et résumé quotidien
- 📅 **Calendrier visuel** de progression
- 🎨 **Thèmes clair et sombre** avec design moderne
- 🏷️ **Catégories** colorées pour organiser vos habitudes
- 💡 **Citations motivantes** d'Atomic Habits
- 🔔 **Système de rappels** avec notifications locales programmées
- ✏️ **Édition d'habitudes** complète avec suppression
- 📊 **Écran de statistiques** avec graphiques interactifs (fl_chart)
- 🔄 **Sauvegarde et restauration** des données locales
- 🎯 **Écran d'accueil** avec résumé quotidien
- ⚙️ **Paramètres** et configuration
- 🚀 **Onboarding** pour nouveaux utilisateurs

### 🚧 À compléter
- Synchronisation cloud (optionnel)

## 🏗️ Architecture

```
lib/
├── core/                    # Configuration de base
│   ├── constants/          # Constantes, couleurs, styles
│   ├── themes/             # Thèmes light/dark
│   ├── router/             # Navigation GoRouter
│   └── utils/              # Utilitaires
├── domain/                  # Logique métier
│   ├── models/             # Modèles de données
│   └── repositories/       # Interfaces repositories
├── infrastructure/          # Implémentation technique
│   ├── database/           # Base de données Drift
│   └── repositories/       # Implémentation repositories
├── application/            # Logique applicative
│   ├── providers/          # Providers Riverpod
│   └── services/           # Services (notifications, etc.)
└── presentation/           # Interface utilisateur
    ├── screens/            # Écrans
    └── widgets/            # Widgets réutilisables
```

## 📚 Les 4 Lois du Changement (Atomic Habits)

### 1. 🔍 Rendre évident (Make it Obvious)
Créez des signaux visuels clairs pour déclencher votre habitude.
- Mettre ses chaussures de sport à côté du lit
- Placer son livre sur l'oreiller
- Afficher son objectif sur l'écran de verrouillage

### 2. ❤️ Rendre attrayant (Make it Attractive)
Associez votre habitude à quelque chose que vous aimez.
- Écouter sa musique préférée pendant l'exercice
- Se récompenser avec un café après la lecture
- Faire l'habitude avec un ami

### 3. ⚡ Rendre facile (Make it Easy)
Réduisez la friction et rendez l'habitude aussi simple que possible.
- Commencer par 2 minutes seulement
- Préparer son environnement à l'avance
- Utiliser la règle des 2 minutes

### 4. ⭐ Rendre satisfaisant (Make it Satisfying)
Célébrez vos victoires et rendez l'habitude gratifiante.
- Marquer un X sur son calendrier
- Suivre sa progression visuellement
- Se féliciter à voix haute

## 🚀 Installation

### Prérequis
- Flutter SDK (>=3.5.0)
- Dart SDK
- Android Studio / Xcode

### Étapes

1. **Cloner le projet**
```bash
cd atomic_habits_app
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Lancer l'application**
```bash
flutter run
```

## 🔧 Configuration

### Base de données
L'application utilise **Drift** (anciennement Moor) pour la gestion de la base de données SQLite locale.

Les tables :
- `habits` : Stocke les habitudes avec toutes leurs propriétés
- `habit_logs` : Enregistre chaque complétion d'habitude

### State Management
**Riverpod** est utilisé pour la gestion d'état avec :
- Providers pour l'accès aux données
- StateNotifier pour les actions
- FutureProvider / StreamProvider pour les données asynchrones

### Navigation
**GoRouter** gère la navigation déclarative avec :
- Routes nommées
- Paramètres de route
- Animations personnalisées

## 💾 Modèles de données

### Habit (Habitude)
```dart
- name: Nom de l'habitude
- description: Description détaillée
- category: Catégorie (Santé, Productivité, etc.)
- frequency: Fréquence (Quotidien, Hebdomadaire, Personnalisé)
- identityStatement: "Je suis quelqu'un qui..."
- twoMinuteVersion: Version 2 minutes de l'habitude
- cue: 1ère loi - Rendre évident
- craving: 2ème loi - Rendre attrayant
- response: 3ème loi - Rendre facile
- reward: 4ème loi - Rendre satisfaisant
- currentStreak: Série actuelle
- longestStreak: Meilleure série
- totalCompletions: Nombre total de complétions
```

### HabitLog (Journal)
```dart
- habitId: ID de l'habitude
- completedAt: Date et heure de complétion
- note: Note optionnelle
- mood: Humeur (1-5)
- wasEasy: L'habitude était-elle facile ? (booléen)
```

## 🎨 Thèmes et Couleurs

### Catégories avec couleurs
- 💗 Santé : Rose
- 💜 Productivité : Violet
- 💙 Apprentissage : Bleu
- 💚 Social : Vert
- 🧡 Créativité : Ambre
- 🩵 Finance : Cyan
- ❤️ Sport : Rouge
- 💜 Mindfulness : Indigo

### Couleurs de streak
- 0-6 jours : Gris (Nouveau)
- 7-13 jours : Bleu (Démarrage)
- 14-20 jours : Vert (Construction)
- 21-29 jours : Ambre (Fort)
- 30+ jours : Rouge (En feu!)

## 📝 Exemples de données fictives

### Habitudes d'exemple
```dart
1. Faire du sport
   - Catégorie: Sport
   - Version 2 min: "Mettre mes chaussures de sport"
   - Cue: "Laisser mes chaussures près du lit"
   - Craving: "Écouter ma playlist énergisante"
   - Response: "Faire 5 pompes pour commencer"
   - Reward: "Cocher ma liste et prendre une photo"

2. Lire 30 minutes
   - Catégorie: Apprentissage
   - Version 2 min: "Lire une page"
   - Cue: "Placer mon livre sur mon oreiller"
   - Craving: "Me faire un thé et m'installer confortablement"
   - Response: "Commencer par une seule page"
   - Reward: "Noter mes insights dans mon journal"

3. Méditer
   - Catégorie: Mindfulness
   - Version 2 min: "Prendre trois respirations profondes"
   - Cue: "Alarme sur mon téléphone à 7h"
   - Craving: "Utiliser mon coussin de méditation préféré"
   - Response: "Juste 2 minutes pour commencer"
   - Reward: "Marquer mon calendrier avec une étoile"
```

## 🔔 Notifications

Le système de notifications utilise `flutter_local_notifications` pour les rappels quotidiens programmés:

```dart
// Exemple de configuration
await notificationService.scheduleHabitReminder(
  habitId: 1,
  habitName: "Faire du sport",
  time: TimeOfDay(hour: 7, minute: 0),
);
```

Les notifications incluent également des messages de milestone pour célébrer les séries réussies.

## 💾 Sauvegarde et Restauration

L'application inclut un service de sauvegarde programmatique pour exporter et importer vos habitudes au format JSON :

```dart
// Exporter toutes les habitudes
final backupService = BackupService(repository);
final file = await backupService.exportToFile();
await backupService.shareBackup();

// Importer depuis un fichier
final importedCount = await backupService.importFromFile(file);
```

*Note: L'interface utilisateur pour la sauvegarde sera ajoutée dans une future mise à jour.*

## 🧪 Tests

```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter test integration_test
```

## 📊 Métriques clés

L'application suit ces métriques importantes :
- ✅ Taux de complétion (pourcentage d'habitudes complétées)
- 🔥 Streak actuel (jours consécutifs)
- 🏆 Plus longue série
- 📈 Total de complétions
- 📊 Tendance hebdomadaire/mensuelle

## 🎯 Principes d'Atomic Habits implémentés

1. ✨ **Amélioration de 1%** : Petits progrès quotidiens
2. 🎭 **Identité** : "Je suis quelqu'un qui..."
3. ⚙️ **Systèmes > Objectifs** : Focus sur le processus
4. ⏱️ **Règle des 2 minutes** : Rendre le démarrage facile
5. 🔗 **Empilement d'habitudes** : Lier aux habitudes existantes
6. 🏅 **Rendre visible** : Suivi visuel des progrès
7. 💪 **Ne jamais manquer deux fois** : Maintenir la chaîne

## 📖 Ressources

- 📘 [Atomic Habits par James Clear](https://jamesclear.com/atomic-habits)
- 🎨 [Flutter Documentation](https://flutter.dev/docs)
- 🔄 [Riverpod](https://riverpod.dev/)
- 🗄️ [Drift](https://drift.simonbinder.eu/)
- 🧭 [GoRouter](https://pub.dev/packages/go_router)

## 📄 Licence

Ce projet est un exemple éducatif basé sur les concepts du livre "Atomic Habits" de James Clear.

## 🙏 Remerciements

Merci à James Clear pour son livre inspirant "Atomic Habits" qui a permis la création de cette application.

---

**Note**: Cette application est un projet de démonstration pour illustrer l'implémentation des concepts d'Atomic Habits dans une app Flutter moderne avec Clean Architecture.
