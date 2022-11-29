# image de base
FROM python:3.6-alpine
MAINTAINER lsniryniry
#definir le repertoire de travail
WORKDIR /opt
# mettre à jour le container et installer les dépendances
# installation de flask
RUN pip install flask==1.1.2
# creation de l'user 'appuser'
RUN addgroup -S appuserr && adduser -S -G appuserr appuserr
# creation du dossier data
ENV ODOO_URL https://www.odoo.com/
ENV PGADMIN_URL https://www.pgadmin.org/
# exposition du port 8080
EXPOSE 8080
COPY . /opt
# lancement de la commande au lancement du container
CMD [ "python", "./app.py" ]
# Switch to 'appuserr'
USER appuserr