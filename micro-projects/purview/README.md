Créer le module avec New-ModuleManifest.ps1
NE PAS OUBLIER DE SUPPRIMER LE FICHIER .psd1


# Objectif du projet
Ce projet a pour but de fournir une boîte à outils modulaire pour automatiser et gérer les différentes solutions offertes par Microsoft Purview (ex. DLP, Data Classification, Insider Risk Management, etc.).

Chaque solution est traitée comme un module indépendant, avec ses propres fonctions PowerShell organisées de manière réutilisable, afin de répondre à divers cas d’usage selon les besoins des projets.


## Exemple pour le module DLP
**Étapes principales :**
- Déploiement initial d’un blueprint
    Permet de déployer rapidement une politique DLP (par exemple EXO PII ou PIPEDA) sur un tenant client, en utilisant les Sensitive Information Types (SITs) intégrés (built-in).

- Mise à jour avec des SITs personnalisés
    Une fois les SITs personnalisés créés, le script met à jour les règles DLP afin de remplacer les types intégrés par ces nouveaux types.

- Utilisation de AdvancedRule
    Le champ AdvancedRule permet de définir l’ensemble des conditions d’une règle DLP dans un seul bloc logique. Ce bloc peut ensuite être réutilisé dans d'autres règles à travers plusieurs politiques DLP (EXO, SPO, ODB, etc.).

    Par exemple, on peut définir une structure de conditions pour couvrir les cas liés à la détection de données personnelles (PII), et la réutiliser dans différentes règles/politiques selon les services.


### Structure des modules
Chaque solution Purview (DLP, Data Classification, etc.) dispose de :

- Un module PowerShell dédié
- Des fonctions organisées dans des fichiers .ps1
- Une structure pensée pour la réutilisation et l’automatisation
- La possibilité d’importer les modules dans différents projets selon les besoins