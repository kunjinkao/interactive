module.exports = {
  webPort: 8001,
  oscPort: 9000,
  pages: [
    { rootUrl: '/', dirName: './app' }
  ],
  clients: [
    { ip: '127.0.0.1', appPort: 9001 }
  ]
}