FROM node:26.7.0-alpine3.24

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci

COPY . .

EXPOSE 3000

RUN addgroup -g 1001 -S appuser && adduser -u 1001 -S appuser -G appuser
RUN chown -R appuser:appuser /usr/src/app

USER appuser

CMD ["node", "src/app.js"]