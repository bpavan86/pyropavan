const _role_rightRepository = require('./role_rights.respository');
const dbContext = require('../../Database/dbContext');

module.exports = function (router) {
    const role_rightRepository = _role_rightRepository(dbContext);

    router.route('/role_rights')
        .get(role_rightRepository.getAll)
        .post(role_rightRepository.post)
        .delete(role_rightRepository.delete);  
}
