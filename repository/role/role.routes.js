const _roleRepository = require('./role.respository');
const dbContext = require('../../Database/dbContext');

module.exports = function (router) {
    const roleRepository = _roleRepository(dbContext);

    router.route('/roles')
        .get(roleRepository.getAll)
        .post(roleRepository.post)
        .delete(roleRepository.delete);  
}
