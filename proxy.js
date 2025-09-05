const express = require('express');
const cors = require('cors');
const { DigestClient } = require('digest-fetch'); // ✅ Doğru import
const https = require('https');



const app = express();
const port = 3000;

app.use(cors());

const DAHUA_PROTOCOL = 'http';   // 👈 cihaz web arayüzüne http:// ile giriyorsan bu
const DAHUA_IP = '172.16.14.104';
const DAHUA_USERNAME = 'admin';
const DAHUA_PASSWORD = 'yoda12345';

app.get('/api/records', async (req, res) => {
  const { StartTime, EndTime } = req.query;
  const targetUrl = `${DAHUA_PROTOCOL}://${DAHUA_IP}/cgi-bin/recordFinder.cgi?action=find&name=AccessControlCardRec&StartTime=${StartTime}&EndTime=${EndTime}`;

  try {
    const client = new DigestClient(DAHUA_USERNAME, DAHUA_PASSWORD); // ✅ Burada
  const dahuaResponse = await client.fetch(targetUrl, {
  headers: {
    'Cookie': 'secure'
  }
});
    const data = await dahuaResponse.text();

    res.setHeader('Access-Control-Allow-Origin', '*');
    res.send(data);
  } catch (error) {
    console.error("Proxy hatası:", error);
    res.status(500).send(`Proxy hatası: ${error.message}`);
  }
});

app.listen(port, () => {
  console.log(`>>> ARACI (PROXY) BAŞLATILDI: http://localhost:${port} adresinde çalışıyor.`);
});