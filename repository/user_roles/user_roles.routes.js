const _user_roleRepository = require('./user_roles.respository');
const dbContext = require('../../Database/dbContext');

module.exports = function (router) {
    const user_roleRepository = _user_roleRepository(dbContext);

    router.route('/user_roles')
        .get(user_roleRepository.getAll)
        .post(user_roleRepository.post)
        .delete(user_roleRepository.delete);  
}
