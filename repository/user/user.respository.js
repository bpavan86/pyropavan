var response = require('../../shared/response');
var TYPES = require('tedious').TYPES;

function UserRepository(dbContext) 
{
    function getUsers(req, res) 
    {
        if (req.body.user_account_id) 
        {
            var parameters = [];
            parameters.push({ name: 'user_account_id', type: TYPES.Int, val: req.body.user_account_id });
            dbContext.post("dev.sp_sel_getusers", parameters, function (error, data) 
            {
                return res.json(response(data, error));
            });
        }
        else 
        {
            dbContext.get("dev.sp_sel_getusers", function (error, data) 
            {
                return res.json(response(data, error));
            });
        }
    }

    function postUser(req, res) 
    {
        var parameters = [];
        parameters.push({ name: 'given_name', type: TYPES.VarChar, val: req.body.given_name });
        parameters.push({ name: 'surname', type: TYPES.VarChar, val: req.body.surname });
        parameters.push({ name: 'email', type: TYPES.VarChar, val: req.body.email });
        parameters.push({ name: 'phone', type: TYPES.VarChar, val: req.body.phone });
        dbContext.post("dev.sp_mod_InsUptUsers", parameters, function (error, data) 
        {
            return res.json(response(data, error));
        });
    }

    function deleteUser(req, res) 
    {
        var parameters = [];
        parameters.push({ name: 'user_account_id', type: TYPES.Int, val: req.body.user_account_id });
        dbContext.post("dev.sp_mod_DeleteUsers", parameters, function (error, data) {
            return res.json(response(data, error));
            });
    }

    return {
        getAll: getUsers,
        post: postUser,
        delete: deleteUser
    }
}

module.exports = UserRepository;