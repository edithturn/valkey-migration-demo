#!/usr/bin/env bash
set -euo pipefail

CLI="docker exec source redis-cli"

echo "Waiting for source Redis..."
until $CLI ping | grep -q PONG; do sleep 1; done

# Session store
$CLI SET session:user:1042 '{"uid":1042,"role":"admin","expires":1800}'   EX 1800
$CLI SET session:user:2891 '{"uid":2891,"role":"viewer","expires":900}'   EX 900
$CLI SET session:user:4417 '{"uid":4417,"role":"editor","expires":3600}'  EX 3600

# Shopping carts
$CLI HSET cart:8821 item:101 2 item:203 1 item:445 5
$CLI HSET cart:9034 item:88  1 item:301 3

# Rate limiting counters
$CLI SET rate_limit:api:203 42 EX 60
$CLI SET rate_limit:api:891 17 EX 60

# Feature flags
$CLI SET feature:dark_mode    1
$CLI SET feature:beta_checkout 0

echo "Done. $(docker exec source redis-cli DBSIZE) keys in source Redis."
