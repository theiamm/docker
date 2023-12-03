# Stage 1: Install temporary build dependencies
FROM python:3.8-alpine as builder

RUN apk add --update --no-cache --virtual .tmp-build-deps \
    gcc libc-dev linux-headers postgresql-dev

# Stage 2: Install Python dependencies
FROM builder as dependencies

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Stage 3: Final image
FROM python:3.8-alpine

# Copy dependencies from the builder stage
COPY --from=dependencies /usr/local /usr/local

# Remove temporary build dependencies
RUN apk del .tmp-build-deps

# Create a non-root user
RUN adduser -D user

# Set the working directory and copy the app files
WORKDIR /app
COPY ./app /app

# Switch to the non-root user
USER user
