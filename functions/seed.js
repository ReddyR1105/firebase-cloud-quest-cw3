const { initializeApp } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const challenge = require('./challenge.json');

async function main() {
  if (process.env.FIRESTORE_EMULATOR_HOST !== '127.0.0.1:8080') {
    throw new Error('Set FIRESTORE_EMULATOR_HOST to 127.0.0.1:8080.');
  }
  initializeApp({ projectId: 'demo-firebase-cloud-quest-cw3' });
  await getFirestore().doc('challenges/today').set(challenge);
  console.log('Seeded challenges/today in the Firestore emulator.');
}
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
