#!/usr/bin/env bash

API_URL="${API_URL:-http://localhost:3000/api/users}"
COUNT=20

FIRST_NAMES=(
  "Alice" "Bob" "Carol" "David" "Eve" "Frank" "Grace" "Henry" "Ivy" "Jack"
  "Karen" "Liam" "Mona" "Noah" "Olivia" "Peter" "Quinn" "Rosa" "Sam" "Tina"
  "Ulysses" "Vera" "Walter" "Xena" "Yusuf" "Zoe"
)
LAST_NAMES=(
  "Smith" "Johnson" "Brown" "Taylor" "Anderson" "Clark" "Lewis" "Walker"
  "Hall" "Young" "King" "Wright" "Scott" "Green" "Baker" "Adams" "Nelson"
)

rand() {
  echo $((RANDOM % $1))
}

created=0
for ((i = 1; i <= COUNT; i++)); do
  first="${FIRST_NAMES[$(rand ${#FIRST_NAMES[@]})]}"
  last="${LAST_NAMES[$(rand ${#LAST_NAMES[@]})]}"
  name="$first $last"
  email="$(echo "$first" | tr '[:upper:]' '[:lower:]').$(echo "$last" | tr '[:upper:]' '[:lower:]')$((RANDOM % 1000))@example.com"
  age=$((18 + RANDOM % 60))

  response=$(curl -s -w "\n%{http_code}" -X POST "$API_URL" \
    -H "Content-Type: application/json" \
    -d "{\"name\": \"$name\", \"email\": \"$email\", \"age\": $age}")

  http_code=$(echo "$response" | tail -n1)
  if [ "$http_code" = "201" ] || [ "$http_code" = "200" ]; then
    created=$((created + 1))
    echo "[$i/$COUNT] OK ($http_code): $name <$email>, age $age"
  else
    echo "[$i/$COUNT] FAILED ($http_code): $name <$email>, age $age"
    echo "$response" | head -n-1
  fi
done

echo "Done. Created $created/$COUNT users into $API_URL"
