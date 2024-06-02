from typing import Union
from fastapi import FastAPI
from .model import get_model

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}

@app.get("/model/{version}")
def version_model(item_id: str):
    model = get_model(item_id)
    return {"Test": "get model"}