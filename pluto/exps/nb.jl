function plotsel(scalefactor=32000, rot1 = -29.6, rot2 = -36.6; w = 900, h = 700)

    overlays = @from site in lls begin
        @where occursin("e", site.sitename)
        @select {site.sitename, site.lon, site.lat}
        @collect DataFrame
    end
    rot3 = 0
    proj = :naturalEarth1
    land10mfile = repo * "/data/aegean10m_tj.json"
    land10m = JSON.parsefile(land10mfile)
    data=VegaDatasets.VegaJSONDataset(land10m,land10mfile)

    @vlplot(width=w, height=h) +
    @vlplot(
        projection={
			type=proj,
			rotate=[rot1,rot2,rot3],
			scale=scalefactor
		},
        mark={
            :geoshape,
            fill=:lightgray,
            stroke=:white
        },
        data={
            values=data,
            format={
                type=:topojson,
                feature=:aegean10m
            }
        }
    )  	+ 
    @vlplot(
    :circle,
	 projection={
		type=proj,
		rotate=[rot1,rot2,rot3],
		scale=scalefactor
	},
    data=lls,
    longitude="lon:q",
    latitude="lat:q",
    size={value=12},
    color={value=:orange} 
    ) +
    @vlplot(
    :circle,
	 projection={
		type=proj,
		rotate=[rot1,rot2,rot3],
		scale=scalefactor
	},
    data=overlays,
    longitude="lon:q",
    latitude="lat:q",
    size={value=5},
    color={value=:steelblue} 
    )   +
    @vlplot(
        mark={
            type=:text,
            dy=-10,
            color=:steelblue
        },
        projection={
            type=proj,
            rotate=[rot1,rot2,rot3],
            scale=scalefactor
        },
        data=overlays,
        longitude="lon:q",
        latitude="lat:q",
        text={
            field=:sitename,
            type=:nominal
        }
    )
end

function plotnames(scalefactor=32000, rot1 = -29.6, rot2 = -36.6; w = 900, h = 700)

    overlays = @from site in lls begin
        @where site.sitename == "Mylasa"
        @select {site.sitename, site.lon, site.lat}
        @collect DataFrame
    end

    rot3 = 0
    proj = :naturalEarth1
    land10mfile = repo * "/data/aegean10m_tj.json"
    land10m = JSON.parsefile(land10mfile)
    data=VegaDatasets.VegaJSONDataset(land10m,land10mfile)
    @vlplot(width=w, height=h) +
    @vlplot(
        projection={
			type=proj,
			rotate=[rot1,rot2,rot3],
			scale=scalefactor
		},
        mark={
            :geoshape,
            fill=:lightgray,
            stroke=:white
        },
        data={
            values=data,
            format={
                type=:topojson,
                feature=:aegean10m
            }
        }
    ) 	+ 
    @vlplot(
    :circle,
	 projection={
		type=proj,
		rotate=[rot1,rot2,rot3],
		scale=scalefactor
	},
    data=lls,
    longitude="lon:q",
    latitude="lat:q",
    color={value=:orange} 
    )   +
    @vlplot(
        mark={
            type=:text,
            dy=-10,
            color=:steelblue
        },
        projection={
            type=proj,
            rotate=[rot1,rot2,rot3],
            scale=scalefactor
        },
        data=overlays,
        longitude="lon:q",
        latitude="lat:q",
        text={
            field=:sitename,
            type=:nominal
        }
    )
    
end

function plotall(scalefactor=20000, rot1 = -29.5, rot2 = -36.7; w = 900, h = 500)
    rot3 = 0
    proj = :naturalEarth1
    land10mfile = repo * "/data/aegean10m_tj.json"
    land10m = JSON.parsefile(land10mfile)
    data=VegaDatasets.VegaJSONDataset(land10m,land10mfile)

	
		
    @vlplot(width=w, height=h) +
    @vlplot(
        projection={
			type=proj,
			rotate=[rot1,rot2,rot3],
			scale=scalefactor
		},
        mark={
            :geoshape,
            fill=:lightgray,
            stroke=:white
        },
        data={
            values=data,
            format={
                type=:topojson,
                feature=:aegean10m
            }
        }
    ) 	+ 
	@vlplot(
		 projection={
			type=proj,
			rotate=[rot1,rot2,rot3],
			scale=scalefactor
		},
		mark={
            :geoshape,
            fill=:transparent,
            stroke=:steelblue
        },
			
        data={
            values=grat,
            format={
                type=:topojson,
                feature=:graticule
            }
        }
	) + 
	@vlplot(
    :circle,
	 projection={
		type=proj,
		rotate=[rot1,rot2,rot3],
		scale=scalefactor
	},
    data=lls,
    longitude="lon:q",
    latitude="lat:q",
    color={value=:orange} 
)
end



function plotallx(scalefactor=2000, rot1 = -40, rot2 = -36; w = 600, h = 300)
    rot3 = 0
    proj = :naturalEarth1
    land10mfile = repo * "/data/land-10m.json"
    land10m = JSON.parsefile(land10mfile)
    d=VegaDatasets.VegaJSONDataset(land10m,land10mfile)

		
    @vlplot(width=w, height=h) +
    @vlplot(
        projection={
			type=proj,
			rotate=[rot1,rot2,rot3],
			scale=scalefactor
		},
        mark={
            :geoshape,
            fill=:lightgray,
            stroke=:white
        },
        data={
            values=d,
            format={
                type=:topojson,
                feature=:land
            }
        }
    ) 	+
	@vlplot(
		 projection={
			type=proj,
			rotate=[rot1,rot2,rot3],
			scale=scalefactor
		},
		mark={
            :geoshape,
            fill=:transparent,
            stroke=:steelblue
        },
			
        data={
            values=grat,
            format={
                type=:topojson,
                feature=:graticule
            }
        }
	) +
	@vlplot(
    :circle,
	 projection={
		type=proj,
		rotate=[rot1,rot2,rot3],
		scale=scalefactor
	},
    data=lls,
    longitude="lon:q",
    latitude="lat:q",
    color={value=:orange} 
    )  +
    @vlplot(
        mark={
            type=:text,
            dy=-10
        },
        data=lls,
        longitude="lon:q",
        latitude="lat:q",
        text={
            field=:sitename,
            type=:nominal
        }
    )
end
