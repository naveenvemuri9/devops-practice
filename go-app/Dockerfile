FROM golang:1.10
WORKDIR /
COPY main.go .
RUN go get -d github.com/gorilla/mux
CMD ["go","run","main.go"]
EXPOSE 8000
