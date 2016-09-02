geomag-edge
=============

A lightweight configuration of an EDGE/CWB node in a container.


Running the Docker image
------------------------
A version of the image created by this project is available on docker hub.
```
docker run -d --name localedge -p 2060:2060 usgs/geomag-edge
```


Building the Docker image
-------------------------
From the root of the project, run:
```
docker build -t usgs/geomag-edge:latest .
```


Related Projects
--------------------

- [EDGE/CWB wiki](https://github.com/usgs/edgecwb/wiki)

The Dockerfile downloads the latest release of EDGE/CWB.

- https://github.com/usgs/geomag-algorithms

  Python library to process timeseries data, that can read from and write to an EDGE process.

- https://github.com/usgs/geomag-edge-ws

  JSON and IAGA2002 web service for data stored in EDGE.
