import os
import main.constants as constants
import openai
from ml.app.model.utils import id2path, load_persona, save_persona
# OpenAI API 키 설정
openai.api_key = constants.APIKEY

def train(user_id: str, target_id: str, question: str, answer: str):
    # 기존 페르소나 로드
    persona_path = id2path(user_id)
    persona = load_persona(persona_path)

    # 대화 텍스트
    dialogue = f"\"{target_id}\"가 \"{user_id}\"에게 \"{question}\"라는 물었고, \"{user_id}\"는 \"{answer}\"라고 대답했다."

    # 요약 생성
    # summary = generate_summary(user_id, dialogue)
    summary = dialogue
    # 페르소나 업데이트
    persona += f"- {summary}\n"
    print(f"\n\npersona: {persona}")
    # 업데이트된 페르소나 저장
    save_persona(persona, persona_path)
    
    # 업데이트된 페르소나 출력
    return 0


# 기존 페르소나 로드 함수

# 요약 생성 함수
def generate_summary(id: str, dialogue: str) -> str:
    prompt = f"""
    {dialogue}\n
    ====
    위의 dialogue를 요약해줘. 이건 \"{id}\"의 Persona 에 반영할거야.
    dialogue로부터 질문자가 무엇을 물었고, 응답자가 어떻게 대답했는지를 분석해서 {id}의 특징과 추후 일정(누구와 언제 무엇을 할 것인지)을 요약해줘..
    """
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": "You are a helpful assistant that summarizes dialogues."},
            {"role": "user", "content": prompt}
        ],
        max_tokens=300,
        temperature=0.5,
    )
    return response.choices[0].message['content'].strip()

# 학습 함수




# 예시 사용
# train("user_id", "오늘 날씨 어때? 어디 놀러 갈래???", "그러게 날씨 진짜 좋네. 우리 한강 가자 이따 수업끝나구") #, "my_persona.txt")

# 예시 사용
# answer = run("my_id", "target_id", "오늘 저녁에 뭐 먹을래?") #, "my_persona.txt")
# print(f"Generated Answer: {answer}")
if __name__ == "__main__":
    train("Gun", "Tom", "내일 저녁에 같이 밥 먹자", "좋아. 그러자!")
    train("Gun", "Lily", "너 삼겹살 좋아해?", "아니 나는 무슬림이라 삼겹살 못 먹어")
    train("Gun", "Paul", "너 여자 친구랑 며칠됐더라?", "나 오늘 100일이야!")
    # 내일 저녁에 시간이 괜찮아!