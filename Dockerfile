# Use latest stable channel SDK for building
FROM dart:stable AS build

# Set working directory
WORKDIR /app

# Copy dependency files first for better caching
COPY pubspec.* ./

# Install dependencies
RUN dart pub get

# Copy application source code
COPY . .

# Compile application to native executable
RUN dart compile exe bin/server.dart -o bin/server

# Build minimal production image
# Using scratch for smallest possible image size
FROM scratch

# Copy runtime dependencies from dart image
COPY --from=build /runtime/ /

# Copy compiled application
COPY --from=build /app/bin/server /app/bin/

# Expose application port
# Note: Railway will override this with PORT env variable
EXPOSE 8080

# Health check (optional, commented out for scratch image)
# HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
#   CMD ["/app/bin/server", "--health-check"]

# Run the server
CMD ["/app/bin/server"]
