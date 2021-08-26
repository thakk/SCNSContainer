FROM ubuntu:20.04 AS base

# Base image for building and release

# Generics
RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y git
RUN apt-get install -y apt-transport-https dirmngr gnupg ca-certificates wget
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

# Mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt-get update --allow-insecure-repositories
RUN apt-get install -y mono-devel
RUN apt-get install -y mono-complete

# DotNet 5.0
RUN wget --no-check-certificate -O - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.asc.gpg

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update
RUN apt-get install -y dotnet-sdk-5.0
RUN apt-get install -y aspnetcore-runtime-5.0

# ----------------------------------------------------------------------
# Build stage for SCNS-Toolkit compilation

FROM base AS build

RUN mkdir /build
WORKDIR /build
RUN git clone https://github.com/swoodhouse/SCNS-Toolkit
WORKDIR /build/SCNS-Toolkit/SynthesisEngine
COPY packages /build/SCNS-Toolkit/SynthesisEngine/packages
COPY packages.config /build/SCNS-Toolkit/SynthesisEngine/packages.config
COPY SynthesisEngine.fsproj /build/SCNS-Toolkit/SynthesisEngine/SynthesisEngine.fsproj
RUN find . -type d -exec chmod o+rx {} \;
RUN find . -type f -exec chmod o+r {} \;
RUN msbuild
RUN cp /build/SCNS-Toolkit/SynthesisEngine/packages/Microsoft.Z3.x64.4.8.10/runtimes/ubuntu-x64/native/libz3.so /build/SCNS-Toolkit/SynthesisEngine/bin/Release/libz3.so

# -------------------------------------------------------------------
# Release stage

FROM base AS release

RUN mkdir /SCNS-Toolkit
WORKDIR /SCNS-Toolkit
COPY --from=build /build/SCNS-Toolkit/SynthesisEngine/bin/Release ./

ENTRYPOINT ["mono","/SCNS-Toolkit/SynthesisEngine.exe"]
