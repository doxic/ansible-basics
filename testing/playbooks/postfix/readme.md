Host	smtp.sparkpostmail.com
Port	587
Alternative Port: 2525
Authentication	AUTH LOGIN
Encryption	STARTTLS
Username	SMTP_Injection
Password	0c0c65686cd21e2bdd61b626b95b983549f93815

https://www.sparkpost.com/docs/integrations/postfix/
https://www.linode.com/docs/email/postfix/postfix-smtp-debian7

postfix


echo "body of your email" | mail -s "This is a Subject" -a "From: dominic@doxic.io" dominic.ruettimann@gmail.com
