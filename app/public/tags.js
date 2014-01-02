$("#tags").select2({
	tags:true,
	placeholder:'Tags',
	tokenSeparators: [",", " "],
	multiple:true,
	createSearchChoice:function(term, data) {
		return {id:term, text:term};
	},
	ajax:{
		url:'/tags',
		dataType:'json',
		cache:true,
		data:function(term,page) {
			return {
				q:term
			}
		},
		results: function(data,page) {
			data = _.map(data,function(obj) {
				obj.id = obj._id;
				obj.text = obj.name;
				return obj;
			});
			console.log(data);
			return {results:data};
		},
		formatResult:function(tag) {
			return '<div>' + tag.text + '</div>';
		},
		formatSelection:function(tag) {
			return tag.text;
		}
	}
});