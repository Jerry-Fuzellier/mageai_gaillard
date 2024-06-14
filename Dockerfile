FROM mageai/mageai:latest

ARG MAGE_PROJECT_NAME
ARG MAGE_CODE_PATH
ARG USER_CODE_PATH

WORKDIR ${MAGE_CODE_PATH}

# Replace [project_name] with the name of your project (e.g. demo_project)
COPY ${MAGE_PROJECT_NAME} ${MAGE_PROJECT_NAME}

# Install custom Python libraries
#RUN pip3 install -r ${MAGE_CODE_PATH}requirements.txt
# Install custom libraries within 3rd party libraries (e.g. dbt packages)
RUN python3 /app/install_other_dependencies.py --path ${USER_CODE_PATH}

# Set the MAGE_CODE_PATH variable to the path of the Mage code.
ENV PYTHONPATH="${PYTHONPATH}:${MAGE_CODE_PATH}"

CMD ["/bin/sh", "-c", "/app/run_app.sh"]