import os
import main.constants as constants
import openai
from ml.app.model.utils import id2path, load_persona, save_persona
# OpenAI API 키 설정
openai.api_key = constants.APIKEY

# 응답 생성 함수
def generate_response(my_id:str, target_id:str, P_me:str, Q: str,) -> str:
    prompt = f"""
<{my_id}의 이전 대화>
{P_me}
</{my_id}의 이전 대화>

위 내용은 \"{my_id}\"의 예전 대화 내용이야.
이를 고려해서, \"{target_id}\"가 \"{my_id}\"에게 \"{Q}\"라는 질문을 했을 때,
\"{target_id}\"의 질문의 말투도 고려해서 \"{my_id}\"가 뭐라고 대답할 지를 생성해줘. 
(다른 설명은 덧붙이지 말고, 한글로 적절한 대답만을 만들어줘)
        """
    print("prompt:\n"+prompt)
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": "You are a helpful assistant that generates natural responses based on given personas and context."},
            {"role": "user", "content": prompt}
        ],
        max_tokens=100,
        temperature=0.5,
    )
    return response.choices[0].message['content'].strip()

# 실행 함수
# my_id : 123
def run(my_id: str, target_id: str, question: str):
    # 기존 페르소나 로드
    my_persona_path = id2path(my_id)
    my_persona = load_persona(my_persona_path)
    # 페르소나 분리 (내 페르소나와 타겟 페르소나)

    # 번역 및 톤 제거
    # 사용자 응답 생성
    response = generate_response(my_id, target_id, my_persona, question)

    return response

if __name__ == "__main__":
    response = run("Gun", "John", "내일 저녁에 시간 되면, 둘이서 밥 같이 먹을래?")
    print(response)
    response = run("Gun", "Tom", "아 내일 저녁 메뉴로 돼지갈비 어때?")
    print(response)
    response = run("Gun", "Siri", "야 너 소개팅 받을래?")
    print(response)