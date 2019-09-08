var response = require('../../shared/response');
var TYPES = require('tedious').TYPES;

function RoleRepository(dbContext) 
{
    function getRoles(req, res) 
    {
        if (req.body.role_id) 
        {
            var parameters = [];
            parameters.push({ name: 'role_id', type: TYPES.Int, val: req.body.role_id });
            dbContext.post("dev.sp_sel_GetRoles", parameters, function (error, data) 
            {
                return res.json(response(data, error));
            });
        }
        else 
        {
            dbContext.get("dev.sp_sel_GetRoles", function (error, data) 
            {
                return res.json(response(data, error));
            });
        }
    }

    function postRole(req, res) 
    {
        var parameters = [];
        parameters.push({ name: 'role_name', type: TYPES.VarChar, val: req.body.role_name });
        dbContext.post("dev.sp_mod_InsertRoles", parameters, function (error, data) 
        {
            return res.json(response(data, error));
        });
    }

    function deleteRole(req, res) 
    {
        var parameters = [];
        parameters.push({ name: 'role_id', type: TYPES.Int, val: req.body.role_id });
        dbContext.post("dev.sp_mod_DeleteRoles", parameters, function (error, data) {
            return res.json(response(data, error));
            });
    }

    return {
        getAll: getRoles,
        post: postRole,
        delete: deleteRole
    }
}

module.exports = RoleRepository;