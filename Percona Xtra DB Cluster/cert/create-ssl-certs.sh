#!/bin/bash
set -e
OUTPUT_DIR="/cert"
openssl genrsa 2048 > "${OUTPUT_DIR}/ca-key.pem"
openssl req -new -x509 -nodes -days 3600 -subj "/C=/ST=/L=/O=/CN=" -key "${OUTPUT_DIR}/ca-key.pem" -out "${OUTPUT_DIR}/ca.pem"
openssl req -newkey rsa:2048 -days 3600 -subj "/C=/ST=/L=/O=/CN=" \
        -nodes -keyout "${OUTPUT_DIR}/server-key.pem" -out "${OUTPUT_DIR}/server-req.pem"
openssl rsa -in "${OUTPUT_DIR}/server-key.pem" -out "${OUTPUT_DIR}/server-key.pem"    
openssl x509 -req -in "${OUTPUT_DIR}/server-req.pem" -days 3600 -subj "/C=/ST=/L=/O=/CN=" \
        -CA "${OUTPUT_DIR}/ca.pem" -CAkey "${OUTPUT_DIR}/ca-key.pem" -set_serial 01 -out "${OUTPUT_DIR}/server-cert.pem"
openssl req -newkey rsa:2048 -days 3600 -subj "/C=/ST=/L=/O=/CN=" \
        -nodes -keyout "${OUTPUT_DIR}/client-key.pem" -out "${OUTPUT_DIR}/client-req.pem"
openssl rsa -in "${OUTPUT_DIR}/client-key.pem" -out "${OUTPUT_DIR}/client-key.pem"
openssl x509 -req -in "${OUTPUT_DIR}/client-req.pem" -days 3600 -subj "/C=/ST=/L=/O=/CN=" \
        -CA "${OUTPUT_DIR}/ca.pem" -CAkey "${OUTPUT_DIR}/ca-key.pem" -set_serial 01 -out "${OUTPUT_DIR}/client-cert.pem"
openssl verify -CAfile "${OUTPUT_DIR}/ca.pem" "${OUTPUT_DIR}/server-cert.pem" "${OUTPUT_DIR}/client-cert.pem"