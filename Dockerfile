# Python base image for windows container
FROM python:3.10

# Create a work directory in the container
WORKDIR /user/src/app

# Copy the app directory to docker
COPY /app .
COPY requirements.txt .

# pip upgrade
# RUN python -m pip install --upgrade pip

# Install PyAudio after installing all the needed dependencies

# https://stackoverflow.com/a/67763666/9223726
# RUN apt-get update
# RUN apt-get install libasound-dev libportaudio2 libportaudiocpp0 portaudio19-dev -y
# RUN pip install pywin32
# RUN python pywin32_postinstall.py -install
# RUN python -m pip install pywin32

# Install all the required dependecies 

# https://stackoverflow.com/questions/43184887/dll-load-failed-error-when-importing-cv2
#   native_module = importlib.import_module("cv2")
#   File "C:\Python\lib\importlib\__init__.py", line 126, in import_module
#     return _bootstrap._gcd_import(name[level:], package, level)
# ImportError: DLL load failed while importing cv2: The specified module could not be found
# RUN pip install opencv_python‑3.2.0‑cp36‑cp36m‑win_amd64.whl

# USER ContainerAdministrator
# RUN curl -fSLo vc_redist.x64.exe https://download.microsoft.com/download/6/A/A/6AA4EDFF-645B-48C5-81CC-ED5963AEAD48/vc_redist.x64.exe 
# RUN start /w vc_redist.x64.exe /install /quiet /norestart
# RUN del vc_redist.x64.exe

# SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; ` 
# RUN Invoke-WebRequest "https://aka.ms/vs/17/release/vc_redist.x64.exe" -OutFile "vc_redist.x64.exe"; ` 
# RUN Start-Process -filepath C:\vc_redist.x64.exe -ArgumentList "/install", "/passive", "/norestart" -Passthru | Wait-Process; ` 
# RUN Remove-Item -Force vc_redist.x64.exe;

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    $ProgressPreference = 'SilentlyContinue'; \
    Invoke-WebRequest -Uri "https://aka.ms/vs/17/release/vc_redist.x64.exe" -OutFile "vc_redist.x64.exe"; \
    Start-Process -filepath ".\vc_redist.x64.exe" -ArgumentList '/install', '/passive', '/norestart' -Wait;\
    Remove-Item -Force -Recurse "vc_redist.x64.exe"

RUN pip install --no-cache-dir -r requirements.txt
# Run the main module
ENTRYPOINT ["python", "./tweety_main.py"]