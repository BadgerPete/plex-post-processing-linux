# plex-post-processing-linux
Linux based post processing with Comskip and Comcut

It will look for files that end with ".ts", check if there
is a cooresponding '.edl' file.  If there is not an edl
file in place it will run Comskip against the .ts file
and create the .edl.

Uses comcut to remove the commercials and reencode as a
mp4 but keeps the edl file for Kodi.
