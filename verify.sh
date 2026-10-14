#!/usr/bin/env bash
set -euo pipefail

SRC="docker exec source redis-cli"
DST="docker exec target valkey-cli"

echo "=== Source (Redis 7.2 :6379) ==="
echo "Keys: $($SRC DBSIZE)"
echo ""

echo "-- Sessions --"
$SRC GET session:user:1042
$SRC GET session:user:2891
$SRC GET session:user:4417
$SRC GET session:new_user

echo ""
echo "-- Carts --"
$SRC HGETALL cart:8821

echo ""
echo "=== Target (Valkey 9.1 :6380) ==="
echo "Keys: $($DST DBSIZE)"
echo ""

echo "-- Sessions --"
$DST GET session:user:1042
$DST GET session:user:2891
$DST GET session:user:4417
$DST GET session:new_user

echo ""
echo "-- Carts --"
$DST HGETALL cart:8821
