FROM node:24-alpine AS builder

WORKDIR /tmp/chat

# To be eventually replaced by clone of a build release
ARG REPO_BRANCH="1.1.x"
ENV REPO_URL="https://gitlab.hallowelt.com/BlueSpice/webservice-chat.git"
ADD "$REPO_URL#$REPO_BRANCH" /tmp/chat/
RUN find . -type d -name '.git' | xargs rm -rf {} \;
RUN npm install

FROM node:24-alpine

WORKDIR /app

COPY root-fs/* ./
COPY --from=builder /tmp/chat ./chat
RUN chmod +x ./chat/start.sh

# Build timestamp (UTC, YmdHis)
RUN mkdir -p /image && date -u +%Y%m%d%H%M%S > /image/BUILDINFO

CMD ["/app/bin/entrypoint"]
