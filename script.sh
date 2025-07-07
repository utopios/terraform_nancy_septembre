#!/bin/bash

set -euo pipefail

# IP publique à utiliser
PUBLIC_IP="188.165.231.159"
URL_PREFIX=""

# Corrige le PATH
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH

# Vérifie que jq est installé
if ! command -v jq >/dev/null 2>&1; then
    echo "❌ jq n'est pas installé. Installe-le avec : sudo apt install jq"
    exit 1
fi

# Vérifie que openstack CLI est installée
if ! command -v openstack >/dev/null 2>&1; then
    echo "❌ La CLI openstack est introuvable. Active ton environnement avec : source ~/devstack/openrc admin admin"
    exit 1
fi

# Vérifie l’authentification
if ! openstack token issue >/dev/null 2>&1; then
    echo "❌ Tu n'es pas authentifié. Fais : source ~/devstack/openrc admin admin"
    exit 1
fi

echo "🔧 Mise à jour des endpoints OpenStack vers l'IP publique : $PUBLIC_IP"

openstack endpoint list -f json | jq -c '.[]' | while read -r ep; do
    ID=$(echo "$ep" | jq -r '.ID')
    SERVICE=$
