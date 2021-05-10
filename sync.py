#!/bin/python

import os.path
import subprocess
from datetime import datetime
from os import environ as env

# Shortcut for env['HOME']. Expands to /home/user/
HOME = env['HOME']

main_branch = 'main'
sync_dirs = []

def parse_paths():
    paths = []
    with open('paths') as f:
        for line in f.readlines():
            # name:path
            line = line.strip('\n')
            print(f'"{line}", {len(line)}')

            if line.startswith('#') or len(line) < 1:
                pass
            else:
                (name, path) = line.split('=')
                path = path.replace('$HOME', HOME).strip('\n')
                name = name.strip('\n')
                
                paths.append((name, path))

    return paths

def init_repo():
    if not os.path.isdir('.git'):
        subprocess.call(['git', 'init'])
        if not os.path.isdir('mirror'):
            subprocess.call(['mkdir', 'mirror'])
    else:
        print('cannot create repo, one already exists')


    # Add README.md to the repo
    subprocess.call(['git', 'add', 'README.md'])
        
def mirror_dir(dirname: str):
    if not os.path.isdir(f'mirror'):
        subprocess.call(['mkdir', '-p', f'mirror'])

    # find the target we need to mirror
    target = None
    for (name, path) in sync_dirs:
        if name == dirname:
            target = (name, path)
            break

    (name, path) = target
    subprocess.call(['cp', '-rf', f'{path}', f'mirror'])
    subprocess.call(['git', 'add', f'mirror/{name}'])

if __name__ == '__main__':
    sync_dirs = parse_paths()

    init_repo()
    for (name, _) in sync_dirs:
        mirror_dir(name)


    extras = ['paths', 'sync.py', '.gitignore']
    for e in extras:
        subprocess.call(['git', 'add', e])
        

    # TODO: commit shit
    now = datetime.now()
    time = now.strftime('%x %X')
    message = f'updated dotfiles ({time})'

    subprocess.call(['git', 'commit', '-m', message])
    subprocess.call(['git', 'push', 'origin', main_branch])
