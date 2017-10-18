FROM ubuntu:latest

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y wget curl less netcat ngrep aptitude build-essential nano vim git-all python screen

WORKDIR /opt

RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-175.0.0-linux-x86_64.tar.gz && tar xvfz google-cloud-sdk-175.0.0-linux-x86_64.tar.gz
RUN wget https://github.com/kubernetes/kubernetes/releases/download/v1.7.8/kubernetes.tar.gz && tar xvfz kubernetes.tar.gz

WORKDIR /root

RUN echo Y | /opt/google-cloud-sdk/install.sh
RUN echo Y | /opt/google-cloud-sdk/bin/gcloud components install alpha
RUN echo Y | /opt/google-cloud-sdk/bin/gcloud components install beta
RUN echo Y | /opt/kubernetes/cluster/get-kube-binaries.sh

RUN sed 's/#force_color_prompt=yes/force_color_prompt=yes/g' .bashrc -i
RUN echo 'cd $HOME' >> .bashrc
RUN echo 'if [ "$TERM" != "dumb"  ]; then' >> .bashrc
RUN echo '  export LESS="-RS#3NM~g"' >> .bashrc
RUN echo '  export EDITOR=nano' >> .bashrc
RUN echo '  alias ll="ls -lh"' >> .bashrc
RUN echo '  alias la="ls -lha"' >> .bashrc
RUN echo '  alias nano="nano -c -w"' >> .bashrc
RUN echo 'fi' >> .bashrc

RUN echo 'source "/opt/google-cloud-sdk/completion.bash.inc"' >> .bashrc
RUN echo 'source "/opt/google-cloud-sdk/path.bash.inc"' >> .bashrc
RUN echo 'export PATH="/opt/kubernetes/client/bin:$PATH"' >> .bashrc

