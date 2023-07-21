import 'package:flutter/cupertino.dart';

class MyCustomPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Crée un nouvel objet Path pour définir le chemin
    Path path = Path();

    // Déplace le point de départ du chemin vers le coin supérieur gauche (0,0)
    path.lineTo(0, size.height * 0.45);
    // Utilise une courbe de Bézier pour définir le trajet de la courbe
    // Le point de contrôle initial est à un tiers de la largeur et à 45% de la hauteur
    // Le point de contrôle final est à deux tiers de la largeur et à 33% de la hauteur
    // Le point d'arrivée est à la largeur complète et à 25% de la hauteur
    path.cubicTo(size.width *0.33, size.height * 0.45, size.width * 0.66, size.height *0.33, size.width, size.height *0.25);

    // Trace une ligne du point d'arrivée jusqu'au coin supérieur droit (largeur complète, 0)
    path.lineTo(size.width, 0);

    // Ferme le chemin a la fin de la courbe
    path.close();

    // Retourne le chemin final
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // retourne true pour que en cas de recharchegement elle repete la courbe
    return true;
  }
  
}

class MyCustomPath2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Crée un nouvel objet Path pour définir le chemin
    Path path = Path();

    // Déplace le point de départ du chemin vers le coin inférieur gauche (0, height)
    path.moveTo(220, size.height);

    // Ajoute une courbe de Bézier qui part du milieu bas de l'écran, monte avant le milieu
    // et se termine au milieu de l'écran à droite
    path.cubicTo(
      size.width * 0.45, size.height * 0.90, // Point de contrôle initial (25% de la largeur, hauteur complète)
      size.width, size.height * 0.80, // Point de contrôle final (50% de la largeur, 75% de la hauteur)
      size.width, size.height * 0.85, // Point d'arrivée (largeur complète, 50% de la hauteur)
    );

    // Trace une ligne du point d'arrivée jusqu'au coin inférieur droit (largeur complète, hauteur complète)
    path.lineTo(size.width, size.height);

    // Ferme le chemin a la fin de la courbe
    path.close();

    // Retourne le chemin final
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // retourne true pour que en cas de rechargement elle répète la courbe
    return true;
  }
}
