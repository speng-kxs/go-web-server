# Fetch the official golang docker image as base
FROM golang:alpine as builder

# switch to the directory inside the container
WORKDIR /home/go-web-server

# copy the source file to container
COPY go.mod .
COPY main.go .

# download the necessary dependency
RUN go mod download

# compile the application
RUN GOOS=linux GOARCH=amd64 go build -o go-web-server


# build a run specific image
FROM alpine as serve
WORKDIR /app

# copy the build file from previous stage
COPY --from=builder /home/go-web-server .

# create non root user to use image
RUN addgroup -S -g 3000 notrootgroup &&\
    adduser -S -u 3000 -G notrootgroup notrootuser

USER 3000:3000

# set env for port and expose it
ENV PORT=3030
EXPOSE $PORT

# specify where the container starts
ENTRYPOINT ["./go-web-server"]