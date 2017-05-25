FROM python:2.7-alpine
MAINTAINER Michael Kraus, michael.kraus@consol.de

EXPOSE 8000

RUN pip install --no-cache-dir prometheus_client
COPY sample_app.py /

CMD ["python2", "/sample_app.py"]

