var students = {{{students}}};
var hws = {{{hws}}};
var submissionPossibilities = students.length * hws.length;
var report = {
	incomplete:students.length * hws.length,
	pendingReview:0,
	complete:0
};

var templates = {};

templates.hw = '<li><a data-toggle="tooltip" class="assignment" href="<% if(submission._id) { %>/hw_submissions/<%= submission._id %><%} %>" title="<%=name%>">\
					<span class="glyphicon <% if(submission._id) {\
													if(submission.complete) { %>\
														glyphicon-ok-sign\
														text-success\
													<% } else { %>\
														glyphicon-question-sign\
														text-warning\
													<% } \
												} else { %>\
													glyphicon-remove-sign\
													text-danger\
												<% } %>"\
				</a></li>';

templates.student = '<li class="media">\
						<a class="pull-left" href="/users/<%=_id%>">\
							<img width="50" class="media-object avatar" src="http://graph.facebook.com/<%=fbData.username%>/picture" alt="<%=first%>" title="<%=first%>">\
						</a>\
						<div class="media-body">\
							<h4 class="media-heading"><%=first%> <%=last%></h4>\
							<ul class="hws pagination" style="margin-top:5px;"></ul>\
						</div>\
					</li>';


var Hw = function(data,student) {
	this.student = student;
	for(key in data) {
		this[key] = data[key];
	}
	this.getSubmissions();
	this.element = $(_.template(templates.hw,this));
	this.student.element.find(".hws").append(this.element);

};

Hw.prototype.getSubmissions = function() {
	this.submission = _.findWhere(this.student.hw_submissions,{hw:this._id}) || {};
	if(this.submission._id) {
		report.incomplete--;
		if(this.submission.complete) {
			report.complete++;
		} else {
			report.pendingReview++;
		}
	}
	return this.submission;
};

var Student = function(data) {
	for(key in data) {
		this[key] = data[key];
	}
	this.element = $(_.template(templates.student,this));
	$(".media-list").append(this.element);
	this.processHw();
};

Student.prototype.processHw = function() {
	this.hws = [];
	for(var i = 0; i < hws.length; i++) {
		this.hws[i] = new Hw(hws[i],this);
	}
};

students = students.map(function(student) {
	return new Student(student);
});


$(".assignment").tooltip({
    placement:"bottom"
});

for(key in report) {
	$("#" + key).css('width',((report[key] / submissionPossibilities)*100) + "%").text(report[key]);
}
