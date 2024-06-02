FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9

WORKDIR /code

# copy requirements
COPY ./requirements.txt /code/requirements.txt

# pip install
RUN pip install --upgrade pip
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# copy app code
COPY ./app /code/app

# run
CMD ["fastapi", "run", "app/main.py", "--port", "80"]