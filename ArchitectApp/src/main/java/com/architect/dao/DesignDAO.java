package com.architect.dao;

import com.architect.db.MongoConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.util.ArrayList;
import java.util.List;

import static com.mongodb.client.model.Filters.eq;

public class DesignDAO {

    private final MongoCollection<Document> collection;

    public DesignDAO() {
        MongoDatabase db = MongoConnection.getDatabase();
        this.collection = db.getCollection("designs");
    }

    public String saveDesign(int userId, String projectName, String jsonData) {
        Document doc = new Document("userId", userId)
                .append("projectName", projectName)
                .append("createdAt", System.currentTimeMillis())
                .append("data", jsonData);

        collection.insertOne(doc);
        return doc.getObjectId("_id").toHexString(); // Return the inserted MongoDB ID
    }

    public void updateDesign(String designId, String projectName, String jsonData) {
        collection.updateOne(
                eq("_id", new ObjectId(designId)),
                new Document("$set", new Document("data", jsonData).append("projectName", projectName))
        );
    }

    public Document loadDesign(String designId) {
        return collection.find(eq("_id", new ObjectId(designId))).first();
    }

    public List<Document> getUserDesigns(int userId) {
        List<Document> designs = new ArrayList<>();
        collection.find(eq("userId", userId)).into(designs);
        return designs;
    }

    public boolean deleteDesign(String designId) {
        return collection.deleteOne(eq("_id", new ObjectId(designId))).getDeletedCount() > 0;
    }
}
