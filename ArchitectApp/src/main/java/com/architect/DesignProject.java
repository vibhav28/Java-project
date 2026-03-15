package com.architect;

import java.util.*;

/**
 * DesignProject.java
 * Holds all design elements for one architecture project.
 * Stored in HttpSession.
 */
public class DesignProject {

    private String name;
    private String author;
    private long   createdAt;
    private final Map<String, DesignElement> elements = new LinkedHashMap<>();
    private int idCounter = 1;

    // Stats
    private int totalWalls    = 0;
    private int totalFloors   = 0;
    private int totalFurniture = 0;

    public DesignProject(String name, String author) {
        this.name      = name;
        this.author    = author;
        this.createdAt = System.currentTimeMillis();
        addDefaultRoom(); // start with a basic room
    }

    /**
     * Adds a starter room: floor + 4 walls
     */
    private void addDefaultRoom() {
        // Floor
        addElement(new DesignElement(nextId(), "FLOOR",
            0, 0, 0, 10, 0.2, 10, 0, "#c8b99a", "WOOD", "Floor"));

        // 4 walls
        addElement(new DesignElement(nextId(), "WALL",
            0, 0, -5, 10, 3, 0.3, 0, "#e8e0d0", "CONCRETE", "North Wall"));
        addElement(new DesignElement(nextId(), "WALL",
            0, 0,  5, 10, 3, 0.3, 0, "#e8e0d0", "CONCRETE", "South Wall"));
        addElement(new DesignElement(nextId(), "WALL",
            -5, 0, 0, 0.3, 3, 10, 0, "#e8e0d0", "CONCRETE", "West Wall"));
        addElement(new DesignElement(nextId(), "WALL",
             5, 0, 0, 0.3, 3, 10, 0, "#e8e0d0", "CONCRETE", "East Wall"));
    }

    public String nextId() {
        return "el_" + (idCounter++);
    }

    public void addElement(DesignElement el) {
        elements.put(el.getId(), el);
        updateStats(el.getType(), 1);
    }

    public boolean removeElement(String id) {
        DesignElement el = elements.remove(id);
        if (el != null) { updateStats(el.getType(), -1); return true; }
        return false;
    }

    public DesignElement getElement(String id) {
        return elements.get(id);
    }

    private void updateStats(String type, int delta) {
        if (type == null) return;
        if (type.equals("WALL"))            totalWalls     += delta;
        else if (type.equals("FLOOR"))      totalFloors    += delta;
        else if (type.startsWith("FURN"))   totalFurniture += delta;
    }

    public void clearAll() {
        elements.clear();
        totalWalls = totalFloors = totalFurniture = 0;
        idCounter  = 1;
        addDefaultRoom();
    }

    /** Serialize all elements to JSON array */
    public String toJson() {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append("\"name\":\"").append(escJson(name)).append("\",");
        sb.append("\"author\":\"").append(escJson(author)).append("\",");
        sb.append("\"totalWalls\":").append(totalWalls).append(",");
        sb.append("\"totalFloors\":").append(totalFloors).append(",");
        sb.append("\"totalFurniture\":").append(totalFurniture).append(",");
        sb.append("\"elementCount\":").append(elements.size()).append(",");
        sb.append("\"elements\":[");
        Iterator<DesignElement> it = elements.values().iterator();
        while (it.hasNext()) {
            sb.append(it.next().toJson());
            if (it.hasNext()) sb.append(",");
        }
        sb.append("]}");
        return sb.toString();
    }

    private String escJson(String s) {
        return s == null ? "" : s.replace("\"", "\\\"");
    }

    // ---- Getters ----
    public String getName()   { return name; }
    public String getAuthor() { return author; }
    public Map<String, DesignElement> getElements() { return elements; }
    public void setName(String n) { this.name = n; }
}
