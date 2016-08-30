# icecast-utils
Various tools and utilities to work with the icecast2 (<http://icecast.org/>) stream server.

# Install
  * Copy *listener-count.xsl* to your public icecast top-level *web* directory.
  * After local modifications (IP address or hostname, etc.), copy *listener-count.pl* to a directory in your ${PATH}
  * Then add something like

    \* \* \* \* \* /bin/pidof icecast > /dev/null && /path/to/listener-count.pl --verbose --output /var/tmp/listener-count >> /var/tmp/listener-count.log

  to your local crontab to snag statistics once per minute.
  * Watch the numbers roll in.

When you call the perl script with the *--verbose* option and direct the output to */var/tmp/listener-count.log*, the file will contain the cumulative statistics in a series of perl-formatted data structures. You can use this to graph the listenership over time.
