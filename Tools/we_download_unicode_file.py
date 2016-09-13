#!/usr/bin/python

# Based on makeunicodedata.py written by Fredrik Lundh (fredrik@pythonware.com)
# See LICENSE-PYTHON for license information.

import os
import sys

if sys.version_info[0] > 2:
    import urllib.request
else:
    from six.moves import urllib

SCRIPT = sys.argv[0]

if len(sys.argv) > 1:
    UNICODE_FILE = sys.argv[1]
else:
    print("usage: ./download-unicode [file] [version]")
    sys.exit(1)

if len(sys.argv) > 2:
    UNIDATA_VERSION = sys.argv[2]
else:
    UNIDATA_VERSION = "9.0.0"

def download_data(template, version):
    local = template % ('-'+version,)
    if not os.path.exists(local):
        if version == '3.2.0':
            url = 'http://www.unicode.org/Public/3.2-Update/' + local
        else:
            url = ('http://www.unicode.org/Public/%s/ucd/'+template) % (version, '')
        urllib.request.urlretrieve(url, filename=local)

if UNICODE_FILE.count("%s") < 1:
    UNICODE_FILE = UNICODE_FILE.replace(".", "%s.")

download_data(UNICODE_FILE, UNIDATA_VERSION)
sys.exit(0)

