FROM python:3.6-alpine
WORKDIR /opt
COPY . /opt
RUN pip install Flask
EXPOSE 8080
ENV ODOO_URL=""
ENV PGADMIN_URL=""
ENTRYPOINT ["python", "app.py"]