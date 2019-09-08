const _rightRepository = require('./right.respository');
const dbContext = require('../../Database/dbContext');

module.exports = function (router) {
    const rightRepository = _rightRepository(dbContext);

    router.route('/rights')
        .get(rightRepository.getAll)
        .post(rightRepository.post)
        .delete(rightRepository.delete);  
}
