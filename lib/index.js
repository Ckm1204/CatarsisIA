// functions/index.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.cleanupOldChats = functions.pubsub
  .schedule('0 4 * * *')  // Runs at 4 AM every day
  .timeZone('America/Mexico_City')  // Adjust to your timezone
  .onRun(async (context) => {
    const yesterday = admin.firestore.Timestamp.fromDate(
      new Date(Date.now() - 24 * 60 * 60 * 1000)
    );

    const usersRef = admin.firestore().collection('users');
    const snapshot = await usersRef.get();

    const batch = admin.firestore().batch();

    for (const userDoc of snapshot.docs) {
      const chatsRef = userDoc.ref.collection('chats');
      const oldChats = await chatsRef
        .where('timestamp', '<', yesterday)
        .get();

      oldChats.docs.forEach((doc) => {
        batch.delete(doc.ref);
      });
    }

    await batch.commit();
    return null;
  });