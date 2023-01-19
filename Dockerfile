# Python base image for windows container
FROM python:3.7.13

# Create a work directory in the container
WORKDIR /user/src/app

# Copy the app directory to docker
COPY /app .
COPY requirements.txt .

# Up
RUN python -m pip install --upgrade pip

#RUN python pywin32_postinstall.py -install
#RUN python -m pip install pywin32
# Install PyAudio after installing all the needed dependencies
# https://stackoverflow.com/a/67763666/9223726
RUN apt-get update
RUN apt-get install libasound-dev libportaudio2 libportaudiocpp0 portaudio19-dev -y
# RUN pip install pywin32
# Install all the required dependecies 
RUN pip install --no-cache-dir -r requirements.txt --user

# Run the main module
ENTRYPOINT ["python", "./tweety_main.py"]