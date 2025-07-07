#!/bin/bash

# Ton IP publique à utiliser dans les nouveaux endpoints
PUBLIC_IP="188.165.231.159"

# Préfixe d'URL, à adapter si Apache ne sert pas sur / (ex: /identity)
URL_PREFIX=""

# Vérifie que la CLI OpenStack est bien authentifiée
if ! openstack token issue > /dev/null 2>&1; then
  echo "❌ Tu dois d'abord faire 'source openrc' ou définir les variables OS_*"
  exit 1
fi

echo "🔧 Mise à jour de tous les endpoints OpenStack vers l'IP publique : $PUBLIC_IP"

# Boucle sur tous les endpoints
openstack endpoint list -f json | jq -c '.[]' | while read -r ep; do
    ID=$(echo "$ep" | jq -r '.ID')
    SERVICE=$(echo "$ep" | jq -r '.Service Name')
    INTERFACE=$(echo "$ep" | jq -r '.Interface')

    # Détermine le bon suffixe d’URL
    case "$SERVICE" in
      identity)    PATH="$URL_PREFIX/identity" ;;
      compute)     PATH="$URL_PREFIX/compute/v2.1" ;;
      image)       PATH="$URL_PREFIX/image" ;;
      network)     PATH="$URL_PREFIX/network" ;;
      placement)   PATH="$URL_PREFIX/placement" ;;
      volumev3)    PATH="$URL_PREFIX/volume/v3" ;;
      *)           PATH="$URL_PREFIX/$SERVICE" ;;
    esac

    # Construit la nouvelle URL
    NEW_URL="http://${PUBLIC_IP}${PATH}"

    echo "🔁 [$SERVICE - $INTERFACE] → $NEW_URL"

    # Applique la mise à jour
    openstack endpoint set "$ID" --url "$NEW_URL"
done

echo "✅ Tous les endpoints ont été mis à jour vers $PUBLIC_IP"
