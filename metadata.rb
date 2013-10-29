name             "gitlab"
maintainer       "Gábor Egyed"
maintainer_email "egyed.gabor@mentha.hu"
license          "MIT"
description      "Installs/Configures gitlab"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

supports "ubuntu"

depends "apt", "~> 1.9.2"
depends "python", "~> 1.3.0"
depends "openssl", "~> 1.0.2"
depends "database", "~> 1.3.12"
depends "nginx", "~> 1.7.0"
depends "cron", "~> 1.2.4"
