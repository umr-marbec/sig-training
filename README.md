# Instructors

* **Names:** David M. Kaplan with assistance from Laure Velez
* **Email:** david.kaplan@ird.fr
* **Website:** http://www.davidmkaplan.fr/

# Course details

* **Required class materials:** A laptop with:
    1) A recent version of Linux, Windows or OSX
    2) A working internet connection (e.g., EDUROAM, Ifremer WiFi, or an internet connection via your cellphone)
    3) Necessary class software installed (see "[Software](#software)" section below)
* **Date:** February 15, 2022
* **Times:** 9h30-12h30
* **Location:** Salle Mont St Clair, Ifremer, Sète ([reservation required](mailto:david.kaplan@ird.fr?&cc=laure.velez@umontpellier.fr&subject=R-GIS:%20Presence%20Salle%20Mont%20St%20Clair)) & by video (link to be determined)

# Software

This class will primarily use [R](https://cran.r-project.org/) in [RStudio](https://www.rstudio.com/), but briefly to visualize some of the GIS layers I will make use of [QGIS](https://www.qgis.org/), an open-source GIS platform (you can also use ArcGIS or another GIS software if you are familiar with it and have it installed, but I will only provide guidance for QGIS). We will also make use of a number of specific R packages for doing GIS in R.

Required software should be installed on your laptop ***before coming to class***. It is particularly important that **Mac users** install the software well before class as my experience is that Macs have more issues with installing this software (likely due to the software being primarily developed and tested on other platforms). If you have any problems installing the software and are unable to find a solution online (please look before contacting me), then please [contact me](mailto:david.kaplan@ird.fr) ***before class starts*** so that we can avoid fixing computer problems during class time.

Details regarding the installation of each software package:

* **[R](https://cran.r-project.org/):** Follow the link to download and install  the ***most recent stable version of R***. If you already have R installed, I highly recommend updating to the latest version to avoid incompatibility issues with the packages to be installed for the class. As R-GIS is developing rapidly, many of the packages are recent and are only fully compatible with the latest versions of R. [Conda](https://www.anaconda.com/products/individual) may be useful if you want to maintain several different versions of R at the same time, but its installation is outside the scope of this class. 
* **[RStudio](https://www.rstudio.com/):** Free integrated development environment (IDE) for R. Again, if you already have Rstudio installed, please update to the most recent stable version before class. 
* **Add-on package for R:** In addition you will need to install a number of free add-on packages for R. See the list of packages to install [below](#r-packages). 
* **[QGIS](https://www.qgis.org/):** Open-source GIS visualization and analysis software that has many of the same functionalities as ArcGIS. Even if you already have ArcGIS, I encourage you to install this as it is powerful and does not require a license as ArcGIS does.

## R packages

R packages add functionality to R and having at least a few of them is essential to working with R. A long list of packages available for R can be found at the [Comprehensive R Archive Network (CRAN)](https://cran.r-project.org/). In addition to a great deal of other useful R documentation, the Rstudio website maintains a good list of [recommended packages](https://support.rstudio.com/hc/en-us/articles/201057987-Quick-list-of-useful-R-packages) for R.

Below is a list of packages that I want you to install ***before coming to class***. If you already have some of these packages installed, then please update to the most recent versions of the packages to assure optimal compatibility and functionality.

* **General packages:** dplyr, tidyr, magrittr, tidyverse, lubridate, lattice, ggplot2, foreign
* **R-GIS:**
    * **Required:** sf, tmap, tmaptools, leaflet, DBI, RPostgreSQL, sp, raster, rgdal, rgeos, htmltools
    * **Recommended:**  ggmap, maps, maptools, stars, spatial, gstat

The easiest way to install packages is from inside Rstudio via the "Install" button on the Packages tab or via *Tools &rarr; Install Packages*. However, packages can also be installed from the command line. For example, the following code will attempt to install all required and recommended packages:
   

```{r eval=FALSE}
install.packages(c("dplyr", "tidyr", "magrittr", "tidyverse", "lubridate", 
                   "lattice", "ggplot2", "foreign"))
install.packages(c("sf", "tmap", "tmaptools", "leaflet", "DBI", "RPostgreSQL", "sp",
                   "raster", "rgdal", "rgeos", "htmltools"))
install.packages(c("ggmap", "maps", "maptools", "stars", "spatial", "gstat"))
```

If you have trouble installing any of these packages, then please [contact me](mailto:david.kaplan@ird.fr) ***before class***. Worse case scenario, we will go over it in class, but I want to minimize the amount of time we spend fixing installation problems during class.

# Data download

Before class, please download the following zipped files containing the spatial layers and other data we will use in class:

* [shapefiles.zip](https://www.davidmkaplan.fr/classes/2022-02-r-gis-marbec/shapefiles.zip)
* [data.zip](https://www.davidmkaplan.fr/classes/2022-02-r-gis-marbec/data.zip)

We will unzip the files and use them during class.
