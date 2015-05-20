moment = require('moment')

function getEntriesWithIDBetween (time1, time2, userId, sequelizeModel, successCb, errorCb) {
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

function getAllEntriesBetween (time1, time2, sequelizeModel, successCb, errorCb) {
  sequelizeModel.findAll({
    where: {
      createdAt: {
          $lt: time2 
          , $gt: time1 
      }
    }
  })
  .then(successCb)
  .error(errorCb)
}


exports.getEntriesWithIDBetween = getEntriesWithIDBetween 
exports.getAllEntriesBetween = getAllEntriesBetween 
