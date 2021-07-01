<p align="center">
    <img src="https://writefreely.org/img/writefreely.svg" width="350px" alt="WriteFreely" />
</p>

WriteFreely is a clean, minimalist publishing platform made for writers. Start a blog, share knowledge within your organization, or build a community around the shared act of writing.

___

This project aim to provide an easy way to deploy WriteFreely using docker.
It currently doesn't provide any docker image, but instead it provides you an easy way to build your own image. I believe that is better, so you can choose the version that you want to deploy (any version or commit from writefreely repository).

The way that it works is pretty simple. It will just clone and build writefreely using Alpine Linux docker image as a base.

## Setup
Clone the repository:

``` sh
git clone https://github.com/karlprieb/writefreely-docker.git
```

Change/fill your writefreely configuration on `config/config.ini`

Open docker-compose.yml file so you can:
* choose the writefreely version that you want
* choose external port
* set the admin username and password
* change the volumes

and lunch:

``` sh
docker-compose up -d
```

It will create/populate data folder with keys, pages, templates and the sqlite db file. You can backup this folder and also change pages and templates. To update pages and templates you need to restart the container.

If you will run writefreely behind a reverse proxy, which is recommended, you will also need to implement that on docker-compose.yml or add the correct networks if you're already running a reverse proxy.

Please feel free to open issues, reporting problems or to request new features. Also open new PRs if you feel that make sense. 😁
