# Stage 1: Builder
FROM node:18-alpine AS builder

WORKDIR /app

# Copiar archivos de definición de paquetes
COPY package*.json ./

# Instalar dependencias limpias para construcción
# Limpieza de caché de npm para reducir tamaño de capas
RUN npm install && npm cache clean --force

# Copiar el resto del código fuente
COPY . .

# Stage 2: Runtime
FROM node:18-alpine

WORKDIR /app

# Definir variables de entorno por defecto
ENV NODE_ENV=production
ENV PORT=3000

# Copiar dependencias y código fuente desde el stage builder
COPY --from=builder /app /app

# Crear usuario no root por seguridad (node image ya trae un usuario llamado "node")
RUN chown -R node:node /app

# Cambiar al usuario no root
USER node

# Exponer el puerto
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["node", "server.js"]
