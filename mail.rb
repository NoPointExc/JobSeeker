require 'net/smtp'
require 'mail'

class MailClient

	#String server
	#int port
	def initialize(server,port)
		@smtp=Net::SMTP.start server, port
		if @smtp==nil || !@smtp.started?
			puts "Failed to reach SMTP server #{server}:#{port}"
			#return false
		else
		puts "Success contect to SMTP server #{server}:#{port}"
		end
		#return true			
	end
	
	#String account
	#String pwd
	def login(account,pwd)
			puts "try to login as #{account}"
			if !@smtp.capable_login_auth?
				puts 'Error: login auth not supported'
				return false
			end
			@smtp.auth_login account,pwd
			puts "Success login as #{account}"
			return true
	end
	
	#String from
	#String to: who reveice this msg
	#String subject
	#String body
	def send(from,to,subject,body)
		mail=Mail.new do
			from from
			to to
			subject subject
			body body
			end
					
		puts "sendding to #{to} ..."
		@smtp.send_mail mail.to_s, from, [to]
		puts "Success send to #{to}"
		return true	
	end
	
	def finish 
		if @smtp.started?
			@smtp.finish	
		end
		puts "disconnected"
	end

	def status
		 puts "started?=#{@smtp.started?}"
	end
end

Class parser
end

def testMail
	server='smtp.yeah.net'
	port=25
	from='jiayang_sun@yeah.net'
	account=from
	to='go2intel@163.com'
	pwd='sun7261030'
	subject='test my script'
	body='this is body'
	client=MailClient.new server, port
	client.status
	client.login account, pwd
	client.send from,to, subject, body
	client.finish
end
