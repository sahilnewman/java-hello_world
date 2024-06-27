#!/bin/bash
# Update and install Java
sudo yum update -y
sudo yum install -y java-1.8.0-openjdk-devel

# Create the application directory
sudo mkdir -p /opt/java-app

# Move to the application directory
cd /opt/java-app

# Create the HelloWorld.java file
sudo cat <<EOF > HelloWorld.java
import java.io.IOException;
import java.io.OutputStream;
import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;
import java.net.InetSocketAddress;

public class HelloWorld {
    public static void main(String[] args) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress(8080), 0);
        server.createContext("/", new MyHandler());
        server.setExecutor(null); // creates a default executor
        server.start();
        System.out.println("Server started on port 8080");
    }

    static class MyHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange t) throws IOException {
            String response = "Hello, World!";
            t.sendResponseHeaders(200, response.length());
            OutputStream os = t.getResponseBody();
            os.write(response.getBytes());
            os.close();
        }
    }
}
EOF

# Compile the Java application
sudo javac HelloWorld.java

# Run the Java application
sudo nohup java HelloWorld > /var/log/java-app.log 2>&1 &
