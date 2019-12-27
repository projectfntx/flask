FROM python:3.6-alpine

RUN adduser -D tutorial

WORKDIR /Users/nillan/Documents/fanatex/python/flask

COPY requirements.txt requirements.txt
RUN python -m venv venv
#RUN venv/bin/pip install -r requirements.txt
#RUN venv/bin/pip install gunicorn

RUN \
 apk add --no-cache postgresql-libs && \
 apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
 venv/bin/pip install -r requirements.txt --no-cache-dir && \
 venv/bin/pip install gunicorn && \
 venv/bin/pip install gunicorn postgres && \
 apk --purge del .build-deps


COPY app app
COPY migrations migrations
COPY tutorial.py config.py boot.sh ./
RUN chmod +x boot.sh

ENV FLASK_APP tutorial.py

RUN chown -R tutorial:tutorial ./
USER tutorial

EXPOSE 5000

ENTRYPOINT ["./boot.sh"]
