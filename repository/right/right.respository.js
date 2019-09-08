var response = require('../../shared/response');
var TYPES = require('tedious').TYPES;

function RightRepository(dbContext) 
{
    function getRights(req, res) 
    {
        if (req.body.right_id) 
        {
            var parameters = [];
            parameters.push({ name: 'right_id', type: TYPES.Int, val: req.body.right_id });
            dbContext.post("dev.sp_sel_getRights", parameters, function (error, data) 
            {
                return res.json(response(data, error));
            });
        }
        else 
        {
            dbContext.get("dev.sp_sel_GetRights", function (error, data) 
            {
                return res.json(response(data, error));
            });
        }
    }

    function postRight(req, res) 
    {
        var parameters = [];
        parameters.push({ name: 'right_name', type: TYPES.VarChar, val: req.body.right_name });
        dbContext.post("dev.sp_mod_InsertRights", parameters, function (error, data) 
        {
            return res.json(response(data, error));
        });
    }

    function deleteRight(req, res) 
    {
        var parameters = [];
        parameters.push({ name: 'right_id', type: TYPES.Int, val: req.body.right_id });
        dbContext.post("dev.sp_mod_DeleteRights", parameters, function (error, data) {
            return res.json(response(data, error));
            });
    }

    return {
        getAll: getRights,
        post: postRight,
        delete: deleteRight
    }
}

module.exports = RightRepository;