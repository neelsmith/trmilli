


function plotall(scalefactor=2000, rot1 = -40, rot2 = -36; w = 600, h = 300)
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
    )
end
