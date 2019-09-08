var response = require('../../shared/response');
var TYPES = require('tedious').TYPES;

function User_RoleRepository(dbContext) 
{
    function getUserRoles(req, res) 
    {
        if (req.body.user_id || req.body.roles) 
        {
            var parameters = [];
            parameters.push({ name: 'user_id', type: TYPES.Int, val: req.body.user_id });
            parameters.push({ name: 'roles', type: TYPES.VarChar, val: req.body.roles });
            dbContext.post("dev.sp_sel_GetUserRoles", parameters, function (error, data) 
            {
                return res.json(response(data, error));
            });
        }
        else 
        {
            dbContext.get("dev.sp_sel_GetUserRoles", function (error, data) 
            {
                return res.json(response(data, error));
            });
        }
    }

    function postUserRoles(req, res) 
    {
        var parameters = [];
        parameters.push({ name: 'roles', type: TYPES.VarChar, val: req.body.roles });
        parameters.push({ name: 'userid', type: TYPES.Int, val: req.body.userid });
        dbContext.post("dev.sp_mod_InsertUserRoles", parameters, function (error, data) 
        {
            return res.json(response(data, error));
        });
    }

    function deleteUserRoles(req, res) 
    {
        var parameters = [];
        parameters.push({ name: 'roles', type: TYPES.VarChar, val: req.body.roles });
        parameters.push({ name: 'userid', type: TYPES.Int, val: req.body.userid });
        dbContext.post("dev.sp_mod_DeleteUserRoles", parameters, function (error, data) {
            return res.json(response(data, error));
            });
    }

    return {
        getAll: getUserRoles,
        post: postUserRoles,
        delete: deleteUserRoles
    }
}

module.exports = User_RoleRepository;