package com.architect;

import com.architect.dao.DesignDAO;
import org.bson.Document;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;

/**
 * ArchitectServlet.java
 * Central Servlet for the 3D Architecture Designer.
 *
 * GET  /design                    → load main app (design.jsp)
 * GET  /design?action=state       → return project JSON
 * POST /design?action=add         → add a new element
 * POST /design?action=remove      → remove element by id
 * POST /design?action=update      → update element property
 * POST /design?action=clear       → clear all (keep floor)
 * POST /design?action=rename      → rename project
 * POST /design?action=save        → save project JSON to MongoDB (requires auth)
 * POST /design?action=load        → load project JSON from MongoDB 
 * POST /design?action=deleteDesign→ delete project JSON from MongoDB 
 */
// Mapping is defined in web.xml to avoid duplicate mappings when combined with the Tomcat plugin.
public class ArchitectServlet extends HttpServlet {

    private final DesignDAO designDAO = new DesignDAO();

    @Override
    public void init() {
        System.out.println("[ArchitectApp] Servlet initialized.");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        ensureProject(session, (String) session.getAttribute("username"));

        String action = req.getParameter("action");

        if ("state".equals(action)) {
            sendJson(resp, getProject(session).toJson());
            return;
        }

        req.getRequestDispatcher("/design.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        ensureProject(session, (String) session.getAttribute("username"));
        DesignProject project = getProject(session);

        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {

            // ---- Save element to MongoDB ----------------------------
            case "save": {
                Integer userId = (Integer) session.getAttribute("userId");
                if (userId != null) {
                    designDAO.saveDesign(userId, project.getName(), project.toJson());
                    resp.getWriter().print("{\"status\":\"saved\"}");
                } else {
                    resp.getWriter().print("{\"status\":\"error\", \"message\":\"Not logged in\"}");
                }
                return; // Early return because we send back simple JSON, not full state
            }

            // ---- Load element from MongoDB --------------------------
            case "load": {
                String designId = param(req, "id", "");
                Document doc = designDAO.loadDesign(designId);
                if (doc != null) {
                    String jsonData = doc.getString("data");
                    // Optionally, we could parse JSON back to DesignProject, 
                    // but it's simpler to send to frontend to process.
                    sendJson(resp, jsonData); 
                    return;
                }
                break;
            }

            // ---- Delete design from MongoDB -------------------------
            case "deleteDesign": {
                String designId = param(req, "id", "");
                designDAO.deleteDesign(designId);
                resp.sendRedirect("dashboard.jsp");
                return;
            }

            // ---- Add element ----------------------------------------
            case "add": {
                String type     = param(req, "type",     "WALL");
                double x        = dbl(req, "x",      0);
                double y        = dbl(req, "y",      0);
                double z        = dbl(req, "z",      0);
                double width    = dbl(req, "width",  1);
                double height   = dbl(req, "height", 3);
                double depth    = dbl(req, "depth",  0.3);
                double rotY     = dbl(req, "rotY",   0);
                String color    = param(req, "color",    "#e8e0d0");
                String material = param(req, "material", "CONCRETE");
                String label    = param(req, "label",    type);

                DesignElement el = new DesignElement(
                    project.nextId(), type,
                    x, y, z, width, height, depth,
                    rotY, color, material, label
                );
                project.addElement(el);
                break;
            }

            // ---- Remove element ------------------------------------
            case "remove": {
                String id = param(req, "id", "");
                project.removeElement(id);
                break;
            }

            // ---- Update element property ---------------------------
            case "update": {
                String id  = param(req, "id", "");
                String prop = param(req, "prop", "");
                String val  = param(req, "val", "");
                DesignElement el = project.getElement(id);
                if (el != null) applyUpdate(el, prop, val);
                break;
            }

            // ---- Clear all -----------------------------------------
            case "clear": {
                project.clearAll();
                break;
            }

            // ---- Rename project ------------------------------------
            case "rename": {
                String newName = param(req, "name", "My Design");
                project.setName(newName);
                break;
            }
        }

        sendJson(resp, project.toJson());
    }

    // ---- Helpers ------------------------------------------------

    private void applyUpdate(DesignElement el, String prop, String val) {
        try {
            switch (prop) {
                case "x":         el.setX(Double.parseDouble(val));         break;
                case "y":         el.setY(Double.parseDouble(val));         break;
                case "z":         el.setZ(Double.parseDouble(val));         break;
                case "width":     el.setWidth(Double.parseDouble(val));     break;
                case "height":    el.setHeight(Double.parseDouble(val));    break;
                case "depth":     el.setDepth(Double.parseDouble(val));     break;
                case "rotationY": el.setRotationY(Double.parseDouble(val)); break;
                case "color":     el.setColor(val);                         break;
                case "material":  el.setMaterial(val);                      break;
                case "label":     el.setLabel(val);                         break;
            }
        } catch (NumberFormatException ignored) {}
    }

    private void ensureProject(HttpSession session, String author) {
        if (session.getAttribute("project") == null) {
            String a = (author != null && !author.isEmpty()) ? author : "Architect";
            session.setAttribute("project", new DesignProject("My Design", a));
        }
    }

    private DesignProject getProject(HttpSession session) {
        return (DesignProject) session.getAttribute("project");
    }

    private void sendJson(HttpServletResponse resp, String json) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().print(json);
    }

    private String param(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v != null && !v.isEmpty()) ? v : def;
    }

    private double dbl(HttpServletRequest req, String name, double def) {
        try { return Double.parseDouble(req.getParameter(name)); }
        catch (Exception e) { return def; }
    }
}
