# Conan Exiles Server


## Quick usage with helper script


## Usage with docker



### Launch server

```
docker run -d -P -n=dgs-conan-exiles dgs-conan-exiles:experimental
```

* with options

```
docker run -d -P -n=dgs-conan-exiles -e "DGS_START_OPTIONS=MaxPlayers 40 AdminPassword pass ServerName myname" dgs-conan-exiles:experimental
```

### Stop server

```
docker stop dgs-conan-exiles
```

### Update server

```
docker run -it dgs-conan-exiles dgs_update
```
