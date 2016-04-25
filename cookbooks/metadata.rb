name             'ora-sensu'
maintainer       'Ora'
maintainer_email 'jerry.chen@foundryhq.com'
license          'All rights reserved'
description      'Installs/Configures ora-sensu'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'sensu', '~> 2.10.0'
depends 'uchiwa', '~> 1.1.0'
