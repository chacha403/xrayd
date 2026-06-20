#!/bin/sh

DIR_CONFIG="/etc/xray"

mkdir -p ${DIR_CONFIG}

DIR_TMP="$(mktemp -d)"

DIR_BIN="/opt/xray"

mkdir -p ${DIR_BIN}

# Write configuration
cat << EOF > ${DIR_TMP}/config.json
{
  "inbounds": [
    {
      "tag": "vless-ws-cdn",
      "listen": "0.0.0.0",
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${ID}",
            "flow": ""
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "wsSettings": {
          "path": "${WSPATH}"
        },
        "tlsSettings": {
          "certificates": []
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"]
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv4"
      }
    }
  ]
}

EOF

# Get executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip  -o ${DIR_TMP}/xray_dist.zip

busybox unzip ${DIR_TMP}/xray_dist.zip -d ${DIR_TMP}

# Convert to protobuf format configuration
${DIR_TMP}/xray convert pb -outpbfile ${DIR_CONFIG}/config.pb  ${DIR_TMP}/config.json

# Install xray
install -m 755 ${DIR_TMP}/xray ${DIR_BIN}
install -m 644 ${DIR_TMP}/geoip.dat ${DIR_TMP}/geosite.dat ${DIR_BIN}

rm -rf ${DIR_TMP}

# Run xray
${DIR_BIN}/xray run -config=${DIR_CONFIG}/config.pb
