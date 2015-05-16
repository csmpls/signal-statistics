_ = require 'lodash' 
_math = require('./math.js')(_)

summaryStatistics = (rows) ->

	entries = _.map(rows, 'dataValues')
	signalQualities = _.pluck(entries, 'signal_quality')

	return {
		# the total number of readings
		numReadings: 
			entries.length
		# get the number of readings with good signal quality
		numPerfectReadings: 
			_.countBy(entries, 
				(entry) -> entry.signal_quality > 0)
			.true
		# average signal quality of all readings
		averageSignalQuality:
			_math.average(signalQualities)
		# the standard deviation of signal qualities
		signalQualityStd:
			_math.stdDeviation(signalQualities)
		# mode signal quality
		signalQualityMode:
			_.first(_math.mode(signalQualities))
		# median signal quality
		signalQualityMedian:
			_math.median(signalQualities)
	}

module.exports = summaryStatistics