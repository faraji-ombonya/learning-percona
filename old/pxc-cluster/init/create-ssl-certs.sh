#!/bin/bash
set -e
CERT_DIR=./certs
mkdir -p "$CERT_DIR"
cd "$CERT_DIR"
# Generate CA key and certificate
openssl genrsa -out ca-key.pem 2048
openssl req -new -x509 -nodes -days 3650 \
    -key ca-key.pem \
    -subj "/C=XX/ST=State/L=City/O=Organization/CN=RootCA" \
    -out ca.pem
# Generate server key and CSR
openssl req -newkey rsa:2048 -nodes \
    -keyout server-key.pem \
    -subj "/C=XX/ST=State/L=City/O=Organization/CN=pxc-node" \
    -out server-req.pem
# Sign server certificate with CA
openssl x509 -req -in server-req.pem -days 3650 \
    -CA ca.pem -CAkey ca-key.pem -set_serial 01 \
    -out server-cert.pem
# Restrict permissions
chmod 600 *.pem