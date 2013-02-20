from fabric.api import *
from fabric import colors
import os.path

env.use_ssh_config = True
env.user = 'ubuntu'

if not env.hosts:
    env.hosts = [
        'viewworld.dk',
        'worker1.viewworld.dk',
    ]

def get_agent_pid():
    with settings(
        hide('warnings', 'running', 'stdout', 'stderr'),
        warn_only=True
    ):
        pid = run('cat /var/run/puppet/agent.pid')
        if pid.succeeded:
            if run('ps -p {0}'.format(pid)).succeeded:
                return pid


@task
def start_agent():
    if get_agent_pid() is None:
        with settings(hide('warnings'), warn_only=True):
            res = sudo('puppet agent')
            if res.return_code in (4, 6):
                abort('puppet agent had failures')
    else:
        puts(colors.cyan('Agent already running'))

@task
def stop_agent():
    pid = get_agent_pid()
    if pid:
        sudo('kill {0}'.format(pid))
    else:
        puts(colors.yellow('Agent not running'))

@task
def apply_config():
    pid = get_agent_pid()
    if pid:
        sudo('kill -s SIGUSR1 {0}'.format(pid))
    else:
        puts(colors.yellow('Agent not running'))

@task
def agent_test(noop='off', debug='off'):
    cmd = ['puppet agent', '--test']
    if noop != 'off':
        cmd.append('--noop')
    if debug != 'off':
        cmd.append('--debug')
    sudo(' '.join(cmd))

@task
def ping_agent():
    pid = get_agent_pid()
    if pid:
        puts(colors.green('Agent running'))
    else:
        puts(colors.yellow('Agent not running'))
