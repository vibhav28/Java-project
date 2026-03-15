<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.architect.dao.DesignDAO" %>
<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    DesignDAO designDAO = new DesignDAO();
    List<Document> designs = designDAO.getUserDesigns(userId);
    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - ArchStudio</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:#0f1117; --panel:#161b27; --panel2:#1e2535; --border:#2a3347;
            --accent:#4f8ef7; --accent2:#f7964f; --green:#3dd68c; --red:#f74f4f;
            --text:#e2e8f0; --muted:#94a3b8;
        }
        body {
            background: var(--bg); color: var(--text); font-family: 'DM Sans', sans-serif;
            margin: 0; padding: 0;
        }
        #topbar {
            height: 60px; background: var(--panel); border-bottom: 1px solid var(--border);
            display: flex; align-items: center; padding: 0 40px; justify-content: space-between;
        }
        .logo { font-size: 18px; font-weight: 600; color: var(--accent); }
        .logo span { color: var(--accent2); }
        
        .container { max-width: 900px; margin: 40px auto; padding: 0 20px; }
        
        .card {
            background: var(--panel); border: 1px solid var(--border); border-radius: 10px;
            padding: 20px; margin-bottom: 15px; display: flex; justify-content: space-between;
            align-items: center; box-shadow: 0 8px 22px rgba(0,0,0,0.25);
        }
        .title { font-weight: 600; font-size: 16px; margin-bottom: 5px; }
        .meta { font-size: 12px; color: var(--muted); font-family: 'DM Mono', monospace; }
        
        .btn {
            padding: 9px 16px; border-radius: 8px; cursor: pointer; border: none;
            font-weight: 600; text-decoration: none; font-size: 13px; display: inline-block;
            transition: transform .1s ease, box-shadow .15s;
        }
        .btn-primary { background: var(--accent); color: white; border: 1px solid var(--accent); }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 8px 18px rgba(79,142,247,0.25); }
        
        .btn-danger { background: transparent; color: var(--red); border: 1px solid var(--red); }
        .btn-danger:hover { background: var(--red); color: white; }
        
        .header-btn {
            background: transparent; border: 1px solid var(--border); color: var(--muted);
            padding: 8px 16px; border-radius: 8px; cursor: pointer; text-decoration: none;
            transition: border-color .15s, color .15s, background .15s;
        }
        .header-btn:hover { background: var(--panel2); color: #fff; border-color: var(--accent); }
        
        .empty { text-align: center; color: var(--muted); padding: 40px; border: 1px dashed var(--border); border-radius: 10px; }
    </style>
</head>
<body>
    <div id="topbar">
        <div class="logo">Arch<span>Studio</span> Dashboard</div>
        <div style="display:flex; gap: 15px; align-items:center;">
            <span style="color:#94a3b8">Welcome, <b><%= session.getAttribute("username") %></b></span>
            <a href="design.jsp" class="btn btn-primary">+ New Design</a>
            <a href="auth?action=logout" class="header-btn">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <h2 style="margin-bottom: 30px;">Your Saved Designs</h2>
        
        <% if (designs.isEmpty()) { %>
            <div class="empty">
                You haven't saved any designs yet.<br><br>
                <a href="design.jsp" class="btn btn-primary">Create Your First Design</a>
            </div>
        <% } else { %>
        <% for (Document doc : designs) { 
            String id = doc.getObjectId("_id").toHexString();
            String name = doc.getString("projectName");
            Object createdRaw = doc.get("createdAt");
            long created;
            if (createdRaw instanceof Date) {
                created = ((Date) createdRaw).getTime();
            } else if (createdRaw instanceof Number) {
                created = ((Number) createdRaw).longValue();
            } else {
                created = new Date().getTime();
            }
            String dateStr = sdf.format(new Date(created));
        %>
            <div class="card">
                <div>
                    <div class="title"><%= name %></div>
                    <div class="meta">Created: <%= dateStr %> &nbsp; | &nbsp; ID: <%= id %></div>
                </div>
                <div style="display:flex; gap:10px;">
                    <!-- We load by sending an AJAX POST to /design?action=load, 
                         or easier: redirect to design.jsp?load=ID and let frontend fetch it -->
                    <a href="design.jsp?load=<%= id %>" class="btn btn-primary">Open</a>
                    <form action="design?action=deleteDesign" method="POST" style="margin:0;" onsubmit="return confirm('Delete <%= name %>?');">
                        <input type="hidden" name="id" value="<%= id %>">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
            <% } %>
        <% } %>
    </div>
</body>
</html>
