## Pour obtenir le TenantID d'un client avec son domaine
```
GET https://login.microsoftonline.com/{{domain}}/v2.0/.well-known/openid-configuration
```

## Comment créer un Registered App Multi Tenant
#### Enregistrement de l'application en mode multi-tenant
Dans Microsoft Entra ID, il faut configurer ton application pour être multi-tenant afin qu'elle puisse être utilisée par d'autres organisations.

Aller dans le portail Azure → Azure Entra

Créer une application d'entreprise

Identités Microsoft Entra → Enregistrements d'applications → Nouvelle application

Nom de l'application : Choisis un nom (ex. : "Audit M365 SaaS")

Types de compte pris en charge : Sélectionne Comptes dans n'importe quel annuaire d'organisation (multilocataire)

Redirection URI : Mets une valeur temporaire (ex. : http://localhost:3000 pour tester)

Créer

Activer les permissions pour Microsoft Graph API

Dans ton application → API permissions

Ajouter une permission → Microsoft Graph

Choisir Application permissions (si ton app fonctionne en tâche de fond) ou Delegated permissions (si un utilisateur doit se connecter pour l'utiliser)

Ajouter :

Directory.Read.All (lecture des utilisateurs et groupes)

User.Read.All (lecture des utilisateurs)

AuditLog.Read.All (lecture des logs)

Demander un consentement admin pour valider ces permissions.

Générer un secret client (pour l'authentification)

Certificats et secrets → Nouveau secret client

Stocker le secret généré car il sera affiché une seule fois.

---
#### Déployer ton application pour que d'autres tenants puissent l'accepter
Une application multi-tenant doit être consentie par un administrateur du tenant cible avant qu'elle puisse accéder aux données.

Créer une URL d'autorisation pour le consentement

Remplace {client_id} par l'ID de ton application (trouvable dans Azure → Enregistrements d'application).

Remplace {redirect_uri} par ton URL de redirection enregistrée.
```
https://login.microsoftonline.com/common/adminconsent?client_id={client_id}&redirect_uri={redirect_uri}
```
L'administrateur du tenant client clique sur cette URL, ce qui ouvre une page demandant son consentement.

Après consentement, l'application sera enregistrée dans son tenant, et tu pourras interagir avec Microsoft Graph API en son nom.

---
#### Authentifier ton application et interagir avec Microsoft Graph API
Une fois qu'un client a consenti, ton application peut obtenir un token d'accès pour Microsoft Graph API.

Exemple : Obtenir un token en Python
Tu peux utiliser MSAL (Microsoft Authentication Library) :
```
import requests
from msal import ConfidentialClientApplication

# Infos de ton application
CLIENT_ID = "ton-client-id"
CLIENT_SECRET = "ton-secret"
TENANT_ID = "organizations"  # "organizations" pour multi-tenant
AUTHORITY = f"https://login.microsoftonline.com/{TENANT_ID}"
SCOPES = ["https://graph.microsoft.com/.default"]

# Authentification
app = ConfidentialClientApplication(CLIENT_ID, CLIENT_SECRET, AUTHORITY)
token_response = app.acquire_token_for_client(scopes=SCOPES)

# Vérification du token
if "access_token" in token_response:
    access_token = token_response["access_token"]
else:
    raise Exception("Échec de l'authentification", token_response.get("error_description"))

# Appel à Microsoft Graph API (ex: récupérer les utilisateurs du client)
headers = {"Authorization": f"Bearer {access_token}"}
response = requests.get("https://graph.microsoft.com/v1.0/users", headers=headers)

print(response.json())

```