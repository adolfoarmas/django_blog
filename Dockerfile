FROM python:3.8-alpine

ENV PATH="/scripts:${PATH}"

COPY ./django_project/requirements.txt ./django_project/requirements.txt
RUN apk add --update --no-cache --virtual .tmp
RUN apk add build-base linux-headers
RUN python -m pip install -U --force-reinstall pip
RUN apk add jpeg-dev zlib-dev libjpeg
RUN pip install Pillow
RUN pip install -r ./django_project/requirements.txt
RUN apk del .tmp

RUN mkdir -p /django_project
COPY ./django_project /django_project
COPY ./venv /venv
WORKDIR /django_project
COPY ./scripts /scripts

RUN chmod +x /scripts/*

#RUN mkdir -p /vol/web/media
#RUN mkdir -p /vol/web/static

RUN mkdir -p /vol/web/media
COPY ./django_project/media/. /vol/web/media
RUN mkdir -p /vol/web/static

RUN adduser -D user
RUN chown -R user:user /vol
RUN chmod -R 755 /vol/web
USER user

CMD ["entrypoint.sh"]




