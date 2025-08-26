gradient_text() {
    local text=$1
    local colors=("38;5;046" "38;5;082" "38;5;076" "38;5;084" "38;5;070")
    local index=0
    for (( i=0; i<${#text}; i++ )); do
        echo -ne "\033[${colors[$index]}m${text:$i:1}\033[0m"
        index=$(( (index + 1) % ${#colors[@]} ))
    done
    echo
}

gradient_text ' ░▒▓██████▓▒░░▒▓███████▓▒░░▒▓█▓▒░▒▓████████▓▒░░▒▓██████▓▒░░▒▓███████▓▒░ ░▒▓██████▓▒░  '
gradient_text '░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ '
gradient_text '░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░    ░▒▓██▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ '
gradient_text '░▒▓████████▓▒░▒▓███████▓▒░░▒▓█▓▒░  ░▒▓██▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░ '
gradient_text '░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓██▓▒░    ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ '
gradient_text '░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ '
gradient_text '░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓████████▓▒░░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ '

gradient_text '                                by shmoti                                             '

choice=''
read -p 'Build a script? [yes or no]: ' choice

if [ "$choice" = "yes" ]; then
    echo 'using default token (set in arizona.py source)...'
    
    INPUT_FILE=arizona.py
    if [ ! -f "$INPUT_FILE" ]; then
        echo "Error: File '$INPUT_FILE' not found!"
        exit 1
    fi

    OUTPUT_FILE="${INPUT_FILE%.py}_obf.py"
    API_URL="https://freecodingtools.org/api/v1/obfuscate"

    CODE=$(jq -Rs . < "$INPUT_FILE")

    echo "Sending $INPUT_FILE to obfuscation API..."
    RESPONSE=$(curl -s -X POST "$API_URL" \
      -H "Content-Type: application/json" \
      -d "{\"language\":\"Python\",\"code\":$CODE}")

    OBFUSCATED=$(echo "$RESPONSE" | jq -r '.obfuscated_code // .obfuscated // .code // empty')

    if [ -z "$OBFUSCATED" ]; then
        echo "Error: Could not extract obfuscated code from response:"
        echo "$RESPONSE"
        exit 1
    fi

    echo "$OBFUSCATED" > "$OUTPUT_FILE"
    echo "Obfuscated file saved as $OUTPUT_FILE"
else
    echo "Exiting."
fi
