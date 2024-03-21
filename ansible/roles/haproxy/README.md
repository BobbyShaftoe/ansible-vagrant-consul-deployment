# Ansible HAProxy

[![Build Status](https://semaphoreci.com/api/v1/projects/67cc3c0d-550d-4d99-99ff-b01c40f899cc/552340/badge.svg)](https://semaphoreci.com/evrardjp/ansible-haproxy)

This role installs haproxy based on your configuration, with a simple dict.

## Requirements


openssl if ```haproxy_ssl``` is set to True.

## Role Variables

A lot of variables are available, but only a few of them are really important.

* When ```haproxy_bind_on_non_local``` is set to True, the role will change
  your host sysctls to allow haproxy to bind on non-local ips.
* ```haproxy_defaults```: This is an optional dict containing haproxy's
  "default" configuration directive. You can define all your haproxy default
  there.
* ```haproxy_global```: Same behaviour as ```haproxy_defaults```
* ```haproxy_services```: This is the most important dict, it will define
  your backend and frontend servers. Check HAproxy configuration to have an
  idea about how to configure your servers. An example is given below.

### Fragments

HAproxy "running" configuration is a generated as an assembly of fragments.
Each fragement is generated, based on the dicts explained above
(haproxy_defaults, haproxy_global  and haproxy_services).

Here are a few variables linked to fragment handling:

* ```haproxy_config_fragments_folder``` is the path in which you can store all
  the haproxy configuration files (fragments) before they are merged together
  in the haproxy.cfg file (Defaulted to /etc/haproxy/conf.d).
* ```haproxy_cleanup_fragments``` is a variable that will remove all fragments files
  before regenerating the configuration (Defaulted to False).

### Stats

HAproxy has an internal way of gathering statistics, and can show it to the
user/deployer. Here are variables altering the stats behaviour.

* When ```haproxy_webstats``` is set to True, webstats will be enabled for
  haproxy. You'll have to define the IP/port webstats will bind on
  (with ```haproxy_webstats_bind```) and the authentication credentials
  (with ```haproxy_webstats_auth```)
* Still for the webstats, you can define ```haproxy_webstats_hide_version```,
  ```haproxy_webstats_uri``` and ```haproxy_webstats_realm```.
  The use of these variables should be self explanatory. You can still check
  on HAProxy upstream documentation, if needed.
* ```haproxy_localstats``` is a way to enable/disable local socket for
  managing haproxy. It can be used with hatop and/or socat. By default, the
  local stats socket is enabled, with admin mode. The level of the access
  can be modified by replacing 'level admin' with the level you need
  in the variable ```haproxy_localstats_level```.
* A variable ```haproxy_localstats_timeout``` exists if you want to
  define a timeout on the localstats socket. Cf. upstream documentation.

### SSL/TLS variables

HAproxy can act as a SSL termination tool or can simply "stream" toward
endpoints. The role can make use of provided certificates, or generate
the certificates itself (see below).

Here are variables in relation to these TLS/SSL topics.

* ```haproxy_ssl``` enables HAProxy ssl handling (Default: False). This can
  make HAProxy a SSL connection endpoint.
* ```haproxy_ssl_default_dh_param``` is the variable defining the parameter
  used in the diffie-hellman key exchange algorithm. Upstream default is
  1024, which is insecure, therefore it's defaulted here to 4096 (which
  may be too much for your environement).
* ```haproxy_ssl_bind_cipher_suite```: Cipher suite recommended on
  https://cipherli.st/ (Defaulted to "AES128+EECDH:AES128+EDH"). It's used
  when doing ssl termination. You can override it by setting it to your own
  value.
* ```haproxy_ssl_bind_options```is a string holding the default
  ssl protocols allowed on the bind. You can define your own string.
  Bind options recommended on https://cipherli.st/ are the defaults
  ("no-sslv3 no-tls-tickets force-tlsv12").
* ```haproxy_ssl_cert``` is the path to your public certificate in the
  deployed host
* ```haproxy_ssl_key``` is the path to your private key in the deployed
  host
* ```haproxy_ssl_ca_cert``` is the path to your ca certificate in the
  deployed host
* ```haproxy_ssl_pem``` is the path to the combined certificate in the
  deployed host (combination of certificate - ca - private key)

* When ```haproxy_ssl_self_signed_regen``` is set to True, haproxy will
  regenerate a new self-signed certificate on each role run.
* To change the self-signed certificate subject, edit the
  ```haproxy_ssl_self_signed_subject``` variable. An example can be
  found in the defaults/main.yml file

* Instead of using self signed certificates, your certificates files can
  be uploaded from the deployement host by setting their path on the
  deployment host in the according user variables:
    - ```haproxy_user_ssl_cert```
    - ```haproxy_user_ssl_key```
    - ```haproxy_user_ssl_ca_cert```

### Convenient variables

* ```haproxy_default_backend_options_http``` is a list of the options you can
  use in your haproxy_services definitions (backend) if the backend runs a
  http service. Options set are "forwardfor", "httpchk", "httplog"
* ```haproxy_default_backend_options_https``` is the same as its http
   counterpart, for https use. Options set are "ssl-hello-chk".
* ```haproxy_default_interval``` (Defaulted to 12000) is an interval you can
  use in the service definition. Please confer to haproxy documentation.
* ```haproxy_default_rise``` (Defaulted to 3) is an interval you can use in the
  service definition. Please confer to haproxy documentation.
* ```haproxy_default_fall``` (Defaulted to 3). Documentation -> cf. rise.

### Distributions variables

These variables are defined per distribution, and define package names, paths
to binaries, binaries names, etc. They are stored in vars/ folder (one file
per distro).

* ```haproxy_packagenames``` is the list of packages that will be installed on
  the deployed system. By default, socat hatop and haproxy are installed
  on Ubuntu. The first two are useful for managing haproxy.
* ```haproxy_server_repo``` is the repo used for installing a recent haproxy
  with packages.
* ```haproxy_server_configuration_folder``` is a variable holding the path
  to the haproxy configuration.

## Dependencies

None

## Example Playbook

    ---
    - hosts: all
      vars:
        haproxy_ssl: True
        haproxy_ssl_self_signed_regen: False
        haproxy_services:
          galera:
            frontends:
              - name: galera-external
                binds:
                  - ip: '127.0.0.1:3400'
                  - ip: '127.0.0.1:3401'
                balance_type: 'tcp'
              - name: galera-internal
                binds:
                  - ip: '127.0.0.1:3402'
                balance_type: 'tcp'
            backends:
              - name: galera-backend-servers
                servers:
                  - name: galera-1
                    ip: '127.0.0.1:3307'
                  - name: galera-2
                    ip: '127.0.0.1:3308'
                backups:
                  - name: galera-3
                    ip: '127.0.0.1:3309'
          horizon:
            frontends:
              - name: external
                binds:
                  - ip: '127.0.0.1:9443'
                    ssl_termination: True
                    #ssl_certificate: "/etc/ssl/certs/mycert.pem"
                    ssl_ciphers: "ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS"
                  - ip: '127.0.0.1:9444'
                    ssl_termination: False
                balance_type: 'http'
              - name: internal
                binds:
                  - ip: '127.0.0.1:7443'
                    ssl_termination: True
                  - ip: '127.0.0.1:7444'
                    ssl_termination: False
                balance_type: 'http'
            backends:
              - name: horizon-backends
                servers:
                  - name: horizon-1
                    ip: '127.0.0.1:80'
                  - name: horizon-2
                    ip: '127.0.0.1:81'
                backups:
                  - name: horizon-3
                    ip: '127.0.0.1:82'
      roles:
        - ansible-haproxy


## License

Apache2

## Author Information

Jean-Philippe Evrard <jean-philippe@evrard.me>
