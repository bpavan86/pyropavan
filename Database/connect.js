var Connection = require('tedious').Connection;

var config = {
    server: 'DESKTOP-35BF2AA',
    authentication: {
        type: 'default',
        options: {
            userName: 'KMH_Admin',
            password: 'kmh123'
        }
    },
    options: {
        database: 'KMHApp',
        instanceName: 'PAVANDB',
        rowCollectionOnDone: true,
        useColumnNames: false
    }
}

var connection = new Connection(config);

connection.on('connect', function (err) {
    if (err) {
        console.log(err);
    } else {
        console.log('Database Connected');
    }
});

module.exports = connection;
