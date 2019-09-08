var response = require('../../shared/response');
var TYPES = require('tedious').TYPES;

function Role_RightRepository(dbContext) 
{
    function getRoleRights(req, res) 
    {
        if (req.body.role_id || req.body.rights) 
        {
            var parameters = [];
            parameters.push({ name: 'role_id', type: TYPES.Int, val: req.body.role_id });
            parameters.push({ name: 'rights', type: TYPES.VarChar, val: req.body.rights });
            dbContext.post("dev.sp_sel_GetRoleRights", parameters, function (error, data) 
            {
                return res.json(response(data, error));
            });
        }
        else 
        {
            dbContext.get("dev.sp_sel_GetRoleRights", function (error, data) 
            {
                return res.json(response(data, error));
            });
        }
    }

    function postRoleRights(req, res) 
    {
        var parameters = [];
        parameters.push({ name: 'rights', type: TYPES.VarChar, val: req.body.rights });
        parameters.push({ name: 'roleid', type: TYPES.Int, val: req.body.roleid });
        dbContext.post("dev.sp_mod_InsertRolesRight", parameters, function (error, data) 
        {
            return res.json(response(data, error));
        });
    }

    function deleteRoleRights(req, res) 
    {
        var parameters = [];
        parameters.push({ name: 'rights', type: TYPES.VarChar, val: req.body.rights });
        parameters.push({ name: 'roleid', type: TYPES.Int, val: req.body.roleid });
        dbContext.post("dev.sp_mod_DeleteRoleRights", parameters, function (error, data) {
            return res.json(response(data, error));
            });
    }

    return {
        getAll: getRoleRights,
        post: postRoleRights,
        delete: deleteRoleRights
    }
}

module.exports = Role_RightRepository;