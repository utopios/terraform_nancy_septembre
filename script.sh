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
    SERVICE=$(echo "$ep" | jq -r '."Service Name"')
    INTERFACE=$(echo "$ep" | jq -r '.Interface')

    case "$SERVICE" in
      identity)    PATH="$URL_PREFIX/identity" ;;
      compute)     PATH="$URL_PREFIX/compute/v2.1" ;;
      image)       PATH="$URL_PREFIX/image" ;;
      network)     PATH="$URL_PREFIX/network" ;;
      placement)   PATH="$URL_PREFIX/placement" ;;
      volumev3)    PATH="$URL_PREFIX/volume/v3" ;;
      *)           PATH="$URL_PREFIX/$SERVICE" ;;
    esac

    NEW_URL="http://${PUBLIC_IP}${PATH}"
    echo "🔁 [$SERVICE - $INTERFACE] → $NEW_URL"
    openstack endpoint set "$ID" --url "$NEW_URL"
done

echo "✅ Tous les endpoints ont été mis à jour vers $PUBLIC_IP"
