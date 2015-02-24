Testing
========

Create a `testmail.txt` file by copying `testmail.txt.template`. Just change `rcpt to: `

Then test like this: `cat testmail.txt|telnet [IP] 25`


PHP Mailer
----------

Test with PHP Mailer. Update the destination in `testmail.php` before running:

	>cd /test
	>curl -sS https://getcomposer.org/installer | php
	>php composer.phar install
	>php testmail.php

