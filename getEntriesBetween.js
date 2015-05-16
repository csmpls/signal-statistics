moment = require('moment')

function getEntriesBetween (time1, time2, userId, sequelizeModel, successCb, errorCb) {
  sequelizeModel.findAll({
    where: {
      indra_time: {
        gt: moment(time1).format()
      }
      , indra_time: {
      	lt: moment(time2).format()
      }
      , id: userId
    }
  })
  .then(successCb)
  .error(errorCb)
}

module.exports = getEntriesBetween 
