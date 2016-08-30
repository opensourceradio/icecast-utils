# icecast-utils
Various tools and utilities to work with the icecast2 stream server.

# Install
  * Copy *listener-count.xsl* in your public icecast top-level *web* directory.
  * After local modifications (IP address or hostname, etc.), copy *listener-count.pl* in a directory on your ${PATH}
  * Then add something like
`
* * * * * /bin/pidof icecast > /dev/null && /path/to/listener-count.pl --verbose --output /var/tmp/listener-count
`
  to your local crontab.
  * Watch the numbers roll in.
