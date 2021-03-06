module.exports = ->
	{
		html:{
			Good: "{{student.first}} has demonstrated mastery of HTML. {{student.pronoun.subject}} can now create well-formatted web-based content and understand other people's code. {{student.pronoun.subject}} understands web standards and knows where to look for help when {{student.pronoun.subject}} is stuck. {{student.pronoun.subject}} has a good understanding of how the Internet works. I'm impressed with {{student.pronoun.possessive}} performance in this area."
			OK: "{{student.first}} has learned a great deal of HTML in this course. {{student.pronoun.subject}} has created generally well formatted web-based content. {{student.pronoun.subject}} knows how to communicate problems {{student.pronoun.subject}} is having--an important skill in web development."
			Bad: "{{student.first}} struggled to learn HTML. While {{student.pronoun.subject}} has learned how to create web-based content, {{student.pronoun.possessive}} page structure and formatting skills are poor."
		}
		css:{
			Good: "{{student.first}} readily learned CSS--the framework used to define the aesthetic properties of websites. Not only did {{student.first}} demonstrate the ability to make {{student.pronoun.possessive}} websites look the way {{student.pronoun.subject}} wanted them to, {{student.pronoun.subject}} wrote code that was clean and organized."
			OK: "{{student.first}} demonstrated the ability to make websites graphically appealing with CSS--the framework used to define the aesthetic properties of websites. However, {{student.pronoun.subject}} still needs to work on CSS code organization."
			Bad: "{{student.first}} did not effectively demonstrate proficiency in CSS--the framework used to define the aesthetic properties of websites. {{student.pronoun.subject}} could not make pages appear the way {{student.pronoun.subject}} wanted them to. {{student.pronoun.subject}} wrote code that was unorganized and poorly implemented. {{student.first}} has a lot of work to do before {{student.pronoun.subject}} masters CSS."
		}
		js:{
			Good: "{{student.first}} was able to make web content come to life using javascript. {{student.first}} wrote code that was clean, readable, and performant. {{student.pronoun.posessive}} performance was impressive because it required a solid understanding of programming principles that go far beyond web development. I have no doubt that {{student.first}} can excel in future programming, if {{student.pronoun.subject}} chooses to."
			OK: "{{student.first}} demonstrated the ability to make interactive web content with javascript. {{student.pronoun.subject}} learned a great deal of introductory programming concepts as well. While {{student.first}} struggled somewhat putting all the pieces together and writing truly elegant code, {{student.pronoun.subject}} has met my expectations for javascript."
			Bad: "{{student.first}} had difficulty with javascript concepts this semester. {{student.pronoun.subject}} will need to spend more time working with javascript to become a proficient programmer. {{student.pronoun.possessive}} code requires more attention to organization and clearer comments about the intent."
		}
	}