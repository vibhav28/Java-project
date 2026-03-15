package com.architect.servlet;

import com.architect.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

// Mapping is defined in web.xml to avoid duplicate annotation/descriptor mapping.
public class AuthServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        switch (action) {
            case "register":
                handleRegister(req, resp);
                break;
            case "login":
                handleLogin(req, resp);
                break;
            default:
                resp.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect("login.jsp");
        } else {
            resp.sendRedirect("login.jsp");
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirm");

        if (password == null || !password.equals(confirm)) {
            req.getSession().setAttribute("error", "Passwords do not match.");
            resp.sendRedirect("register.jsp");
            return;
        }

        boolean success = userDAO.register(username, email, password);
        if (success) {
            req.getSession().setAttribute("success", "Registration successful. Please login.");
            resp.sendRedirect("login.jsp");
        } else {
            req.getSession().setAttribute("error", "Registration failed. Username or email might be taken.");
            resp.sendRedirect("register.jsp");
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        Integer userId = userDAO.login(username, password);

        if (userId != null) {
            HttpSession session = req.getSession();
            session.setAttribute("userId", userId);
            session.setAttribute("username", username);
            resp.sendRedirect("dashboard.jsp"); // Successful login goes to dashboard
        } else {
            req.getSession().setAttribute("error", "Invalid username or password.");
            resp.sendRedirect("login.jsp");
        }
    }
}
