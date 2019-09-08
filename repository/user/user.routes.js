const _userRepository = require('./user.respository');
const dbContext = require('../../Database/dbContext');

module.exports = function (router) {
    const userRepository = _userRepository(dbContext);

    router.route('/users')
        .get(userRepository.getAll)
        .post(userRepository.post)
        .delete(userRepository.delete);  
}
