package com.architect;

/**
 * DesignElement.java
 * Represents any element placed in the architecture design.
 * Can be a wall, floor, door, window, furniture, etc.
 */
public class DesignElement {

    private String id;
    private String type;     // WALL, FLOOR, DOOR, WINDOW, ROOF, STAIR, FURNITURE_*
    private double x, y, z;
    private double width, height, depth;
    private double rotationY;   // degrees
    private String color;
    private String material;    // CONCRETE, WOOD, GLASS, BRICK, MARBLE, METAL
    private String label;

    public DesignElement() {}

    public DesignElement(String id, String type,
                         double x, double y, double z,
                         double width, double height, double depth,
                         double rotationY, String color, String material, String label) {
        this.id        = id;
        this.type      = type;
        this.x         = x;
        this.y         = y;
        this.z         = z;
        this.width     = width;
        this.height    = height;
        this.depth     = depth;
        this.rotationY = rotationY;
        this.color     = color;
        this.material  = material;
        this.label     = label;
    }

    public String toJson() {
        return String.format(
            "{\"id\":\"%s\",\"type\":\"%s\"," +
            "\"x\":%.2f,\"y\":%.2f,\"z\":%.2f," +
            "\"width\":%.2f,\"height\":%.2f,\"depth\":%.2f," +
            "\"rotationY\":%.1f,\"color\":\"%s\"," +
            "\"material\":\"%s\",\"label\":\"%s\"}",
            id, type, x, y, z, width, height, depth,
            rotationY, color, material, label
        );
    }

    // ---- Getters & Setters ----
    public String getId()       { return id; }
    public String getType()     { return type; }
    public double getX()        { return x; }
    public double getY()        { return y; }
    public double getZ()        { return z; }
    public double getWidth()    { return width; }
    public double getHeight()   { return height; }
    public double getDepth()    { return depth; }
    public double getRotationY(){ return rotationY; }
    public String getColor()    { return color; }
    public String getMaterial() { return material; }
    public String getLabel()    { return label; }

    public void setId(String id)             { this.id = id; }
    public void setType(String type)         { this.type = type; }
    public void setX(double x)               { this.x = x; }
    public void setY(double y)               { this.y = y; }
    public void setZ(double z)               { this.z = z; }
    public void setWidth(double w)           { this.width = w; }
    public void setHeight(double h)          { this.height = h; }
    public void setDepth(double d)           { this.depth = d; }
    public void setRotationY(double r)       { this.rotationY = r; }
    public void setColor(String color)       { this.color = color; }
    public void setMaterial(String material) { this.material = material; }
    public void setLabel(String label)       { this.label = label; }
}
