require 'net/smtp'
require 'mail'
require 'yaml'
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

def parse
	files=Dir.entries '.'
	mail_lists=Array.new
	has_config=false
	
	for f in files
		if f.end_with? '.mail'
			mail_lists.push f
		elsif f=='config.yml' 
			has_config=true
		end
	end

	if !has_config
		puts "Error: can\'t find config.yml in #{Dir.pwd}"
		return false
	end
	
	if mail_lists.empty?
		puts "Warnning: can\'t find any .mail in #{Dir.pwd}"
		return false
	end

	$configs=YAML.load_file 'config.yml'
	$mails=Array.new
	for l in mail_lists
		tmp=YAML.load_file l
		$mails = $mails + tmp
	end
	puts 'Success read config and mail lists'
	return true
end

def testMail
	server='smtp.yeah.net'
	port=25
	from='xxxxxxx@yeah.net'
	account=from
	to='xxxxxxx@163.com'
	pwd='password'
	subject='test my script'
	body='this is body'
	client=MailClient.new server, port
	client.status
	client.login account, pwd
	client.send from,to, subject, body
	client.finish
end

def testParse
	parse
	puts $configs
	puts $mails
end

parse
account=$configs['account']
pwd=$configs['password']
server=$configs['server']
port=$configs['port']
from=account
debug_receiver=$configs['debug_receiver']
subj=$configs['subject']
body=$configs['body']

client=MailClient.new server, port
client.login account, pwd

send_num=0
for to in $mails
	client.send from,to, subj, body
	send_num=send_num+1
end 

client.finish

puts "----------------------------"
puts "send #{send_num} mails, exit"

