FROM ubuntu

RUN apt-get update -y && apt-get install -y unzip wget git curl && \
    wget https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip && \
    unzip terraform_0.11.8_linux_amd64.zip && \
    mv terraform /usr/local/bin/ 

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV AWS_ACCESS_KEY_ID=YOUR_CREDENTIALS
ENV AWS_SECRET_ACCESS_KEY=YOUR_CREDENTIALS
ENV AWS_DEFAULT_REGION=us-east-1
ENV AWS_DEFAULT_OUTPUT=json
RUN set -xe \
    && apt-get update -y \
    && apt-get install python-pip -y     

