_ = require 'lodash'
fs = require 'fs'
util = require 'util'
moment = require 'moment'
getAllEntriesBetween = require('./getEntriesBetween.js').getAllEntriesBetween

# finds readings between start and end
# in slices of size sliceSizeInSeconds
# so, findReadingInSlices('5pm', '6pm', 60, someModel) will find
# all someModel readings at each 60-second slice between 5p and 6p
findReadingsInSlices = (start, end, sliceSizeInSeconds, interestingIDs, dbModel, db) ->

	recurse = (thisSliceEnd) ->
		findReadingsInSlices(
			thisSliceEnd
			, end
			, sliceSizeInSeconds
			, interestingIDs
			, dbModel
			, db)

	if moment(start).isBefore(end)
		sliceEnd = moment(start).add(sliceSizeInSeconds, 'seconds').format()
		console.log 'between', start, sliceEnd
		getAllEntriesBetween(
			start
			, sliceEnd
			, dbModel
			# success cb
			, (results) ->
				console.log 'found', results.length
				# write summary stats to the log
				log(start, format(oneEntryPerSubject(results, interestingIDs)))
				# recurse to the next one
				recurse(sliceEnd)
			# error cb
			, (err) ->
				console.log 'error!', err 
				recurse(sliceEnd))
	else
		console.log 'done'
		db.close()

log = (time, string) ->
	fs.appendFile(
		PATH_TO_LOGFILE
		, [time, string].join(',') + '\n'
		, (success) -> console.log('wrote', time))

# for each id in interesting IDs
# returns the signal quality of ID in dbResults,
# or -1
oneEntryPerSubject = (dbResults, interestingIDs) ->
	# get db readings
	entries = _.map(dbResults, 'dataValues')
	# extract just the user ID + signal quality for each entry
	# or -1 if that ID isnt represented in entriesPerID
	entryPerID = _.map(interestingIDs, (id) ->
		entry = _.first(_.filter(entries, 'id', id))
		if entry
			return {
				id: id
				signal_quality: entry.signal_quality }
		else
			return {
				id: id
				signal_quality: -1
			})

format = (arrayOfEntries) ->
	_.pluck(arrayOfEntries, 'signal_quality').join(',')

#
#  handy reference
#
MIDSgroup1 = 
	start: '2015-05-09T23:31:57.419+00:00'
	end: '2015-05-09T23:36:57.889+00:00'

MIDSgroup2 = 
	start: '2015-05-09T23:43:34.405+00:00'
	end:'2015-05-09T23:48:34.35+00:00'

idsGroup1 = _.map(
	[334,389,497,523,604,613,659,677,695,721,749,758,244,235,433,640,172,587,226,361,442,505,703,190,424,415,127,136,488]
	, (id) -> String(id))	
idsGroup2 = _.map(
	[118,262,280,325,343,370,398,532,541,569,578,631,668,686,253,299,154,514,145,208,596,712,271,352,307,316,406,730]	
	, (id) -> String(id))	

#
# config
#
PATH_TO_LOGFILE = './timelog1.csv'
IDS_OF_INTEREST = idsGroup1
START_TIME = MIDSgroup1.start
END_TIME = MIDSgroup1.end
SLICE_RESOLUTION_IN_SECONDS = 1

#
# script
#
connectToIndraDatabase = require './db_config.js'
NeuroskySeqeuelizeModel = require 'sequelize-neurosky'

indraDatabase = connectToIndraDatabase()
NeuroskyReading = NeuroskySeqeuelizeModel.define(indraDatabase)

# write the header
header = _.union([['time'], IDS_OF_INTEREST])
log(header.join(','))

# write the data
findReadingsInSlices(
	moment(START_TIME).format()
	, moment(END_TIME).format()
	, SLICE_RESOLUTION_IN_SECONDS
	, IDS_OF_INTEREST
 	, NeuroskyReading
 	, indraDatabase)
