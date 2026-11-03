FROM node:22-bookworm

# Install build dependencies
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Ensure local node_modules is ignored even if .dockerignore was missed
COPY package*.json ./

# Force NPM to rebuild sqlite3 from source completely inside Debian
RUN npm ci --build-from-source=sqlite3

COPY . .

# Remove host binary leftovers if they slipped through
RUN npm rebuild sqlite3 --build-from-source

EXPOSE 3001

CMD ["npm", "start"]