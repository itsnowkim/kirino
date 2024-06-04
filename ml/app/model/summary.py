import os
from ml.app.model.utils import id2path, load_persona
import openai

def summaryPersona(id:str, persona:str) -> str:
    
    prompt = f"""
${persona}
====
위 대화 내용을 토대로, ${id}가 어떤 사람인지를 한국어로 말해줘.
이때 ${id}의 특징, 특성, 성격, 일정들을 각각 포함시켜서 말해줘.
    """
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": "You are a helpful assistant that generates user persona based on given talks."},
            {"role": "user", "content": prompt}
        ],
        max_tokens=100,
        temperatuer=0.5
    )
    return response.choices[0].message["content"].strip()


def getPersona(id: str) -> str:
    persona_path = id2path(id)
    persona = load_persona(persona_path)
    response = summaryPersona(id, persona)
    return response

