FROM python:3.13-slim

WORKDIR radeon/

COPY app.py .

RUN pip install Flask

EXPOSE 5000

CMD [ "python" , "app.py"  ]