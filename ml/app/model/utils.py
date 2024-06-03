import os

PERSONA_DIR="persona"

def id2path(id: str) -> str:
    return f"{PERSONA_DIR}/{id}"

def load_persona(persona_path: str) -> str:
    if os.path.exists(persona_path):
        with open(persona_path, 'r', encoding='utf-8') as file:
            return file.read()
    return ""

def save_persona(persona: str, persona_path: str):
    if not os.path.exists(PERSONA_DIR):
        os.makedirs(PERSONA_DIR)
    with open(persona_path, 'w', encoding='utf-8') as file:
        file.write(persona)