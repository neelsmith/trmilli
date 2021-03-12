function plotoverlays(scalefactor=32000, rot1 = -29.6, rot2 = -36.6; w = 900, h = 700)

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
    size={value=50},
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
    size={value=20},
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