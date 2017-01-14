# SafeMessages on Sinatra

- Production: https://safe-message.herokuapp.com/
- Ruby version: 2.3.0
- Sinatra 1.4.7
- Author : Vadim Ryazantsev (Junior Full-Stack RoR developer)
- Email: v.rtsev@gmail.com
- LinkedIn: https://www.linkedin.com/in/vrtsev

# Description
Create encrypted messages with SafeMessage. Want to send a secret message or other confidential information to friend? This resource allows you to encrypt your messages with a password and send a secure link to the person who should receive this message. Using a secure link and entering your password, you can easily view the secret message.

# Short functionality description:
* Ability to set your own password to encrypt message
* Ability to set self-destryction mode
* Safe encrypted links
* AES encrypting

# Installing and usage
* Clone this repo
* Create postgres database and run "rake db:create"
* run "rake db:migrate"
* run "shotgun" or "rackup"
