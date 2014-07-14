name             "php-apcu"
maintainer       "Michael Beattie"
maintainer_email "beattiem@knights.ucf.edu"
license          "MIT license"
description      "Installs/Configures the mcrypt module for PHP"

version          "1.0.0"

supports 'ubuntu'
supports 'debian'

depends "php"

recipe 'apcu', 'Installs/Configures the apcu module for PHP'