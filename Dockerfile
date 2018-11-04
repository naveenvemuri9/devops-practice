FROM ubuntu

RUN apt-get update -y && apt-get install -y unzip wget git curl && \
    wget https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip && \
    unzip terraform_0.11.8_linux_amd64.zip && \
    mv terraform /usr/local/bin/ 

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV AWS_ACCESS_KEY_ID=AKIAIYJOFC6AR5V2QFBQ
ENV AWS_SECRET_ACCESS_KEY=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
ENV AWS_DEFAULT_REGION=us-east-1
ENV AWS_DEFAULT_OUTPUT=json
RUN set -xe \
    && apt-get update -y \
    && apt-get install python-pip -y     
RUN apt-get install awscli -y
RUN pip install awscli --upgrade --user
RUN pip install awscli --ignore-installed six
RUN curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mkdir /root/bin && cp ./kubectl /root/bin/kubectl 
RUN curl -o $HOME/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x $HOME/bin/aws-iam-authenticator
ENV BINPATH='/root/bin'
ENV PATH="${PATH}:${BINPATH}"
