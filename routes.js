const express = require('express'); 

function eRoutes() {
    const router = express.Router();
    var user = require('./repository/user/user.routes')(router);
    var right = require('./repository/right/right.routes')(router);
    var role = require('./repository/role/role.routes')(router);
    var role_rights = require('./repository/role_rights/role_rights.routes')(router);
    var user_rights = require('./repository/user_roles/user_roles.routes')(router);
    return router;
}

module.exports = eRoutes;