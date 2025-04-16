Copier le folder DLP dans ``$HOME\Documents\WindowsPowerShell\Modules\``


1. Le but est d'être en mesure d'uploader un blueprint de DLP EXO PII ou PIPEDA chez un client avec les SITs build-in.

2. Ensuite, une fois les SITs customs créées, venir faire la mise à jour pour remplacer les build-in avec ceux-ci.

**AdvancedRule est disponible dans une rule et représente les conditions de la rule en un seul bloque et peu être déployer dans n'importe quel rule**
Donc venir définir, par exemple, la structure de condition qui couvre l'ensemble des possibilités du PII. Ensuite, ce bloque pour être déployer dans d'autre règle qui se trouve dans d'autre DLP policy comme EXO, SPO, ODB etc.


créer un module DLP avec des fonctions en .ps1 qui sont importés.
le module peut être importer pour donner accès aux fonctions pour différent projet.