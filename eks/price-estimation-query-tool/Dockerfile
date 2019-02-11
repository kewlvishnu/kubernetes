ARG from="python:3.7-slim"
FROM ${from}

WORKDIR /price-estimate-query

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

ENTRYPOINT [ "python", "main.py" ]
