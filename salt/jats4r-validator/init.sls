system-dependencies:
    pkg.installed:
        - pkgs:
            - python3
            - python3-pip

install-validator:
    file.directory:
        - name: /srv/validator/
        - user: {{ pillar.elife.deploy_user.username }}
        - recurse:
            - user

    git.latest:
        #- name: https://github.com/jats4r/validator
        - name: https://github.com/elifesciences/validator
        - submodules: True
        - target: /srv/validator/
        - require:
            - file: install-validator

    cmd.run:
        - cwd: /srv/validator/
        - name: . ./bin/setenv.sh && ./bin/setup.sh
        - require:
            - git: install-validator

configure-webserver:
    file.managed:
        - name: /etc/nginx/sites-enabled/validator.conf
        - source: salt://jats4r-validator/config/etc-nginx-sitesenabled-validator.conf
        - template: jinja
        - require:
            - cmd: install-validator
