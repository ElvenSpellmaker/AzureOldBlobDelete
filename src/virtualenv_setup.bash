VIRTUALENV_DIRECTORY='/tmp/python-blob-delete'

[ ! -x "$VIRTUALENV_DIRECTORY/bin/python" ] && virtualenv "$VIRTUALENV_DIRECTORY"

source "$VIRTUALENV_DIRECTORY/bin/activate"

pip install --upgrade 'pip==10.0.1'
pip install --upgrade 'wheel==0.30.0'
pip install --upgrade 'setuptools==39.0.1'
pip install --upgrade 'azure-cli==2.0.31'
