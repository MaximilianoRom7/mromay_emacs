import os
import sys


k = None
arg = {}
for key in sys.argv:
	if k:
		arg.update({k: key})
	if key[:2] == '--':
		k = key
	else:
		k = None

path = arg.get('--path')
config = arg.get('--config')
config_path = '/root/.emacs.d/home/odoo-server.conf'

if path and os.path.isdir(path):
        os.chdir(path)
	sys.path = [path + os.sep + 'openerp'] + sys.path
	sys.path = [path + os.sep + 'odoo'] + sys.path
	sys.path = [path + os.sep + 'openerp/tools'] + sys.path
	sys.path = [path + os.sep + 'odoo/tools'] + sys.path
	sys.path = [path] + sys.path
	try:
		i = sys.argv.index('--path')
		sys.argv.pop(i)
		sys.argv.pop(i)
	except:
		pass
else:
	sys.path = [os.getcwd()] + sys.path

if not config and os.path.isfile(config_path):
	sys.argv.append('--config')
	sys.argv.append(config_path)

def tryImport(m, module):
        c = 0
        odoo = None
        while c < 3:
                try:
	                odoo = __import__(module)
                        break
                except ImportError:
                        pass
                except AttributeError:
                        pass
                c += 1
        return odoo

odoo = None
odoo = tryImport(3, 'openerp')
if not odoo:
        odoo = tryImport(3, 'odoo')
        
if odoo:
        odoo.cli.main()
