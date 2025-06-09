class UserLevel {
  final String levelName;
  final int minPoints;
  final int maxPoints;

  UserLevel({required this.levelName, required this.minPoints, required this.maxPoints});

  UserLevel getUserLevel(int points) {
    if (points < 0) {
      return UserLevel(levelName: "Invalid points", minPoints: 0, maxPoints: 0);
    }

    if (points < 100) {
      return UserLevel(levelName: "Seedling 🌱", minPoints: 0, maxPoints: 100);
    } else if (points < 250) {
      return UserLevel(levelName: "Sprout 🍃", minPoints: 100, maxPoints: 250);
    } else if (points < 500) {
      return UserLevel(levelName: "Leaflet 🍂", minPoints: 250, maxPoints: 500);
    } else if (points < 1000) {
      return UserLevel(
        levelName: "Green Guardian 🌿",
        minPoints: 500,
        maxPoints: 1000,
      );
    } else if (points < 2000) {
      return UserLevel(
        levelName: "Eco Warrior ♻️",
        minPoints: 1000,
        maxPoints: 2000,
      );
    } else if (points < 4000) {
      return UserLevel(
        levelName: "Planet Protector 🌍",
        minPoints: 2000,
        maxPoints: 4000,
      );
    } else {
      return UserLevel(
        levelName: "Recycling Champion 🏆",
        minPoints: 4000,
        maxPoints: 4000,
      );
    }
  }
}
