package com.architect.db;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;

public class MongoConnection {
    private static MongoClient mongoClient = null;

    public static MongoDatabase getDatabase() {
        if (mongoClient == null) {
            mongoClient = MongoClients.create("mongodb://localhost:27017");
        }
        return mongoClient.getDatabase("archstudio_designs");
    }

    public static void close() {
        if (mongoClient != null) {
            mongoClient.close();
        }
    }
}
