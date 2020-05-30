# icecast-utils
Various tools and utilities to work with the [Icecast2](http://icecast.org/) stream server.

# NPR/SoundExchange Stream Reporter

`icecast-soundexchange` is a stand-alone Perl script that parses Icecast log files and generates one or more [NPR Digital Services-compliant](http://digitalservices.npr.org/post/soundexchange-streaming-file-format-standard-announced) SoundExchange stream server text files. Optionally, it will place these files in a Zip archive for you (`--zip-file` option). Specify an Icecast log directory (`--log-directory` [default: _/var/log/icecast_]), a start date (`--start-date`), an end date (`--end-date`), and one or more Icecast mount points. Here is an example of using the script on the command line:

    icecast-soundexchange --start-date 01/Mar/2020 --end-date 15/Mar/2020 --zip-file report-2020-q1.zip --mount-points play,high,low

This will generate the named Zip archive containing the text files `play.txt`, `high.txt`, and `low.txt` with records from the stream log between March 1, 2020 and March 15, 2020 (inclusive).

`icecast-soundexchange` uses the Perl modules `Time::Piece`, `Date::Parse`, and `Archive::Zip`. Find them in your Linux distro package manager, or at your favorite [cpan](https://metacpan.org/) archive.

# Listener Count

One way to keep track of the number of stream listeners.

## Install
  * Copy *listener-count.xsl* to your public icecast top-level *web* directory.
  * After local modifications (IP address or hostname, etc.), copy *listener-count.pl* to a directory in your ${PATH}
  * Then add something like

    \* \* \* \* \* /bin/pidof icecast > /dev/null && /path/to/listener-count.pl --verbose --output /var/tmp/listener-count >> /var/tmp/listener-count.log

  to your local crontab to snag statistics once per minute.
  * Watch the numbers roll in.

When you call the perl script with the *--verbose* option and direct the output to */var/tmp/listener-count.log*, the file will contain the cumulative statistics in a series of perl-formatted data structures. You can use this to graph the listenership over time.
