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