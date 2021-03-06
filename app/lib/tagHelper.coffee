async = require 'async'
_ = require 'lodash'
mongoose = require 'mongoose'
module.exports = (Tags)->
	fns = {}


	fns.deepPopulate = (foreignModel,foreignSingular,doc,cb)->
		mongoose.model(foreignModel).populate doc[foreignModel.toLowerCase()], {path:'tags'}, (err,subDocs)->
			return cb err if err?
			subDocs = subDocs.map (subdoc)->
				subdoc[foreignSingular] = doc
				subdoc
			doc[foreignModel.toLowerCase()] = subDocs
			cb null, doc




	# returns fn for async parallel package
	tagOneFn = (tag)->
		self = @
		referenceName = @constructor.modelName.toLowerCase()
		return (callback)->
			Tags.findByName tag,(err,tagDoc)->
				return callback err if err?
				if tagDoc?
					tagDoc[referenceName].addToSet self._id
					tagDoc.save callback
				else
					tagObj = {name:tag}
					tagObj[referenceName] = [self._id]
					Tags.create tagObj, callback

	fns.tag = (tags,cb)->
		self = @
		toResolve = []
		tags = _.map _.uniq tags, (tag) -> tag.toLowerCase()
		for tag in tags
			toResolve.push tagOneFn.call @, tag
		async.parallel toResolve, (err,tagDocs)->
			return cb err if err?
			tagDocs = tagDocs.map (doc)->
				return doc[0] if Array.isArray doc
				doc
			self.tags.addToSet.apply self.tags, _.pluck tagDocs, '_id'
			self.save cb

	# function to remove a specific tag from a set of tags
	fns.removeTag = (tag,cb)->
		self = @
		@tags.pull tag
		@save (err,doc)->
			return cb err if err?
			Tags.findById tag, (err,tagDoc)->
				return cb err if err?
				tagDoc[self.constructor.modelName.toLowerCase()].pull self._id
				tagDoc.save cb

	# # function to call before removal of a doc
	# fns.preRemove = (next)->


	fns

