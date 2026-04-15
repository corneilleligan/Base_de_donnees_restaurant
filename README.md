<div align="center">

# Base de Données — Restaurant

Conception et implémentation d'une BDD relationnelle complète : modèle entité-association, dépendances fonctionnelles, requêtes SQL avancées, déclencheurs et procédures stockées.

![SQL](https://img.shields.io/badge/SQL-MariaDB-blue?style=flat&logo=mariadb&logoColor=white)
![phpMyAdmin](https://img.shields.io/badge/phpMyAdmin-6C78AF?style=flat&logo=phpmyadmin&logoColor=white)
![MIT](https://img.shields.io/badge/Licence-MIT-4f8ef7?style=flat)

<br/>

[Rapport complet](rapport-bdr.pdf)
</div>

---

## Modèle de données

8 tables relationnelles — `CLIENT`, `SERVEUR`, `REPAS`, `PLAT`, `INGREDIENT`, `TABLE_RESTAURANT`, `COMPOSE`, `CONSOMME`

---

## Requêtes SQL

| # | Requête |
|---|---------|
| 1 | Plats servis à la fois par Dupond et Durand |
| 2 | Coût total du repas de la table n° 23 |
| 3 | Serveurs n'ayant jamais servi la lotte au beurre |
| 4 | Clients servis exclusivement par Dupond |
| 5 | Table au coût le plus élevé le 05/11/2025 entre 19h et 23h |

---

## Déclencheur et procédure

**Déclencheur** `verif_disponibilite_plat` — bloque l'insertion dans `CONSOMME` si les stocks d'ingrédients sont insuffisants pour préparer le plat.

**Procédure** `ranger_clients_non_payes` — peuple la table `CLIENTS_NON_PAYES` avec tous les clients dont `a_paye = FALSE`.

---

## Lancement

Importer le fichier SQL dans phpMyAdmin ou via la commande :

```bash
mysql -u root -p < restaurant.sql
```

---

## Auteurs

Projet réalisé en L2 Informatique — Université de Limoges, 2025–2026.
Encadré par M. Olivier Terraz.
