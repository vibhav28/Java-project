# ArchStudio — 3D Architecture Designer

ArchStudio is a web-based 3D computer-aided design (CAD) tool for architects and designers. It features an interactive WebGL canvas that allows users to place, modify, and delete architectural structure components and furniture in a real-time 3D environment. The application is built using a Java Servlet backend, JSP-driven pages, and a Three.js 3D frontend. Design data is kept in-sync via custom AJAX endpoints and can be persisted to a multi-database cloud setup (MySQL + MongoDB).

---

## 🚀 Key Features

*   **Interactive 3D Canvas:** Built with [Three.js](https://threejs.org/) featuring orbit, pan, zoom controls, and a snapping grid helper for easy element alignment.
*   **Structural Elements:** Build with concrete, wood, glass, brick, marble, or metal structures such as Walls, Floors, Roofs, Stairs, Doors, and Windows.
*   **Furniture & Interior Objects:** Place pre-defined space-fillers including Sofas, Tables, Beds, Baths, Desks, and Plants.
*   **Detailed Customization:** Real-time modification of width, height, depth, rotation, color, and materials.
*   **Cloud Save & Open:** Logged-in users can save their project designs directly to a MongoDB collection and manage multiple projects from their dashboard.
*   **Local File Support:** Export designs as JSON files locally, enabling offline backups and data transfer.
*   **Multi-User Authentication:** A secure login and registration flow with password hashing powered by BCrypt.

---

## 🛠️ Technology Stack

*   **Frontend:** HTML5, CSS3 (Modern Dark Theme), JSP (JavaServer Pages), Three.js (WebGL rendering).
*   **Backend:** Java Servlets (Servlet 3.1, JSP 2.3).
*   **Relational Database:** MySQL 8.0 (Stores user accounts and credentials securely).
*   **NoSQL Database:** MongoDB (Stores document-based layout and design data as JSON).
*   **Authentication:** BCrypt (`jbcrypt` 0.4) for password security.
*   **Build System:** Apache Maven (configured for `.war` packaging and embedded Tomcat container execution).

---

## 📁 Project Structure

```text
ArchitectApp/
├── pom.xml                  # Maven Configuration & Dependencies
├── run.bat                  # Script to clean, build and run the application
├── src/
│   └── main/
│       ├── java/
│       │   └── com/architect/
│       │       ├── DesignElement.java     # Model for 3D elements (walls, doors, sofa)
│       │       ├── DesignProject.java     # Class encapsulating the whole design and stats
│       │       ├── ArchitectServlet.java  # Controller for AJAX operations on the design canvas
│       │       ├── dao/
│       │       │   ├── UserDAO.java       # Database operations for authentication (MySQL)
│       │       │   └── DesignDAO.java     # Database operations for design documents (MongoDB)
│       │       ├── db/
│       │       │   ├── MySQLConnection.java # MySQL Connection utility
│       │       │   └── MongoConnection.java # MongoDB Connection utility
│       │       └── servlet/
│       │           └── AuthServlet.java   # Controller for Register, Login, and Logout
│       └── webapp/
│           ├── WEB-INF/
│           │   └── web.xml               # Servlet and session timeout configurations
│           ├── index.jsp                 # Index redirecting to login
│           ├── login.jsp                 # Login form
│           ├── register.jsp              # Account creation form
│           ├── dashboard.jsp             # User projects list and actions
│           └── design.jsp                # Interactive 3D CAD designer canvas
```

---

## 🗄️ Database Schemas

### 1. MySQL: `archstudio_users`
Used to manage registered users. You will need to create this database and user table before starting the server.

```sql
CREATE DATABASE archstudio_users;

USE archstudio_users;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### 2. MongoDB: `archstudio_designs`
Used to persist project data. The application stores layouts inside a collection named `designs`. A typical document contains:
*   `userId`: Refers to the MySQL user ID.
*   `projectName`: The display name of the project.
*   `createdAt`: Unix timestamp of creation.
*   `data`: Stringified JSON containing the metadata and array of placed elements (`DesignElement` details: x, y, z coordinates, dimensions, material type, rotation, color, label).

---

## ⚙️ Setup & Installation

### Prerequisites
1.  **Java Development Kit (JDK):** JDK 8 or JDK 17.
2.  **Apache Maven:** Make sure `mvn` is added to your path.
3.  **MySQL Server:** Running on `localhost:3306`.
4.  **MongoDB Server:** Running on `localhost:27017`.

### Configuration
1.  **MySQL Credentials:** Update the URL, User, and Password fields in [MySQLConnection.java](file:///Users/vibhavthakur/College/coding/projects/Java-project/ArchitectApp/src/main/java/com/architect/db/MySQLConnection.java):
    ```java
    private static final String URL = "jdbc:mysql://localhost:3306/archstudio_users?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "your_mysql_password";
    ```
2.  **MongoDB Credentials:** If your MongoDB runs on a non-default port or requires authentication, update [MongoConnection.java](file:///Users/vibhavthakur/College/coding/projects/Java-project/ArchitectApp/src/main/java/com/architect/db/MongoConnection.java).

### Running the Project

You can compile, build, and deploy the application using the Tomcat Maven plugin:

1.  Navigate to the `ArchitectApp` directory:
    ```bash
    cd ArchitectApp
    ```
2.  Run the Maven Tomcat goal:
    ```bash
    mvn clean install tomcat7:run
    ```
    *Or, if on Windows, run the provided script:*
    ```cmd
    run.bat
    ```
3.  Access the application in your browser:
    ```text
    http://localhost:8080/archstudio
    ```

---

## 🖥️ User Guide & Controls

*   **Designing:**
    *   **Place Mode:** Select a tool (e.g. Wall, Sofa), customize its dimensions/material, and click on the grid to place it.
    *   **Select Mode:** Click an element in the viewport to display and edit its properties (rotation, size, position, color) or delete it.
*   **Camera Navigation:**
    *   **Left Click + Drag:** Orbit around the center point.
    *   **Right Click + Drag:** Pan the viewport camera.
    *   **Scroll Wheel:** Zoom in and out.
*   **Top Bar Operations:**
    *   **☁ Save:** Upload and save the active layout to the cloud (requires logged-in account).
    *   **💾 Export JSON:** Download the layout parameters directly to your computer.
    *   **🗑 Clear All:** Reset the grid back to the starter room.
