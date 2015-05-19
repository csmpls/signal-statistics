_ = require 'lodash'
fs = require 'fs'
util = require 'util'

connectToIndraDatabase = require './db_config.js'
summaryStatistics = require './summaryStatistics.coffee'
getEntriesWithIDBetween = require('./getEntriesBetween.js').getEntriesWithIDBetween
NeuroskySeqeuelizeModel = require 'sequelize-neurosky'

indraDatabase = connectToIndraDatabase()
NeuroskyReading = NeuroskySeqeuelizeModel.define(indraDatabase)

findAllSummaryStats = (ids, startTime, endTime, logName, db) ->

	console.log 'log name is', logName

	format = (id, stats) ->
		util.format(
			'%d, %d, %d, %d, %d, %d, %d\n'
			id
			, stats.numReadings
			, stats.numPerfectReadings
			, stats.averageSignalQuality
			, stats.signalQualityStd
			, stats.signalQualityMode
			, stats.signalQualityMedian)

	log = (id, summaryStats, logName) ->
		fs.appendFile(
			logName
			, format(id, summaryStats)
			, (success) -> console.log('wrote', id))

	recurse = (ids) ->
		if ids.length > 1
			findAllSummaryStats(_.rest(ids), startTime, endTime, logName, db)
		else
			console.log 'done'
			db.close()

	getEntriesWithIDBetween(
		startTime
		, endTime
		, _.first(ids)
		, NeuroskyReading
		, (data) ->
			# print the summary stats
			summary = summaryStatistics(data)
			log(_.first(ids), summary, logName)
			# recurse to the next one
			recurse(ids)
		, (err) ->
			console.log 'error!', err 
			recurse(ids))



MIDSgroup1 = 
	start: '2015-05-09 23:31:57.419+00'
	end: '2015-05-09 23:36:57.889+00'

MIDSgroup2 = 
	start: '2015-05-09 23:43:34.405+00'
	end:'2015-05-09 23:48:34.35+00'

idsGroup1 = _.map(
	[334,389,497,523,604,613,659,677,695,721,749,758,244,235,433,640,172,587,226,361,442,505,703,190,424,415,127,136,488]
	, (id) -> String(id))	
idsGroup2 = _.map(
	[118,262,280,325,343,370,398,532,541,569,578,631,668,686,253,299,154,514,145,208,596,712,271,352,307,316,406,730]	
	, (id) -> String(id))	

findAllSummaryStats(
	idsGroup2
	, MIDSgroup2.start
	, MIDSgroup2.end
	, './group.csv'
	, indraDatabase)
