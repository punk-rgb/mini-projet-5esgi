# Présentation

Cette solution propose le déploiement automatisé d’un écosystème complet pour l’application Odoo (ERP), comprenant :

Odoo (application principale)

PostgreSQL (base de données)

PgAdmin (gestionnaire d’administration PostgreSQL)

Une webapp connectée à Odoo et PgAdmin

Le tout est orchestré dans un namespace dédié, icgroup, et sécurisé via des Secrets et des volumes persistants.

# Architecture des composants
## 1. Namespace

Tous les composants fonctionnent dans le namespace icgroup, permettant une isolation et une gestion plus aisée des ressources liées à ce projet.

## 2. PostgreSQL 

Déployé à partir de l'image officielle postgres:13.

Configuration via un Secret pour l’utilisateur et le mot de passe.

Volume persistant attaché (postgres-pvc) pour la durabilité des données.

Service interne Kubernetes exposé sur le port 5432.

## 3. Odoo

Déployé à partir de l'image officielle odoo:13.0.

Paramétrage de la base de données, de l’utilisateur et du mot de passe via Secret.

Connexion à la base de données Postgres grâce au nom de service DNS Kubernetes postgres.

Volume persistant attaché (odoo-pvc) pour stocker les données d’Odoo.

Service NodePort exposant Odoo sur le port 30082 du cluster.

## 4. PgAdmin

Déployé avec l'image officielle dpage/pgadmin4:latest.

Configuration automatisée des serveurs via un ConfigMap.

Login administrateur et mot de passe gérés par Secret.

Volume persistant attaché (pgadmin-pvc) pour conserver la configuration et l’historique.

Service NodePort exposant PgAdmin sur le port 30081 du cluster.

## 5. Webapp

Application web personnalisée (punkgrb/ic-webapp:1.0) connectée à Odoo et PgAdmin.

Les URLs d’accès d’Odoo et de PgAdmin sont passées via des variables d’environnement :

ODOO_URL: http://54.36.127.113:30082

PGADMIN_URL: http://54.36.127.113:30081/

Service NodePort exposant la webapp sur le port 30080.

## 6. Configuration et Sécurité

Les mots de passe, utilisateurs et emails sont stockés dans des Secrets Kubernetes encodés en base64.

La configuration spécifique à PgAdmin (serveurs PostgreSQL connectés) est gérée par un ConfigMap.

## 7. Stockage Persistent

Chaque composant critique (Odoo, Postgres, PgAdmin) est attaché à un PersistentVolumeClaim pour assurer la récupération des données en cas de redémarrage des Pods.

# Accès aux applications

Odoo : http://[NODE_IP]:30082

PgAdmin : http://[NODE_IP]:30081

Utilisateur/admin : admin@demo.com (mot de passe dans le Secret)

Webapp : http://[NODE_IP]:30080

Remplacer [NODE_IP] par l’adresse IP de votre nœud ou du load balancer.

# Déploiement

Appliquer les fichiers Kubernetes dans l’ordre suivant :

Namespace

Secrets

PersistentVolumeClaims

ConfigMap (pour PgAdmin)

Deployments (Postgres, PgAdmin, Odoo, webapp)

# Services

Vérifier le bon statut des pods via kubectl get pods -n icgroup.

Accéder aux services via l’IP du nœud et les ports NodePort indiqués ci-dessus.

# Personnalisation

Pour adapter les mots de passe et les utilisateurs, modifiez les données des Secrets.

Les ressources, notamment le stockage demandé pour chaque PV, sont configurables dans les PersistentVolumeClaims.

Vous pouvez paramétrer les URL d’accès dans les variables d’environnement de la webapp.

# Schéma d’interconnexion
Odoo ↔ Postgres (stockage des données ERP)
PgAdmin ↔ Postgres (administration de la base de données)
Webapp ↔ Odoo + PgAdmin (interface agrégée pour l’utilisateur)