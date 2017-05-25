# plex-post-processing-linux
Linux based post processing with Comskip and Comcut

It will look for files that end with ".ts", check if there
is a cooresponding '.edl' file.  If there is not an edl
file in place it will run Comskip against the .ts file
and create the .edl.

TODO:
Once edl is in place cut commercials out so plex will
be commercial free.  For now, plex records and does the
post-processing but Kodi is required for cutting out
the commercials.
