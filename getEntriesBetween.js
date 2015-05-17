moment = require('moment')

function getEntriesBetween (time1, time2, userId, sequelizeModel, successCb, errorCb) {
  sequelizeModel.findAll({
    where: {
      createdAt: {
          $lt: time2 
        	, $gt: time1 
      }
      , id: userId
    }
  })
  .then(successCb)
  .error(errorCb)
}

module.exports = getEntriesBetween 
