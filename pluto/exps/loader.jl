#https://github.com/topojson/world-atlas

#=
function plottopo(w = 900, h = 500)
    countries50mfile = repo * "/data/countries-50m.json"
    countries50m = JSON.parsefile(countries50mfile)
    d=VegaDatasets.VegaJSONDataset(countries50m,countries50mfile)
    

    
    @vlplot(width=w, height=h) +
    @vlplot(
        projection={
			type=:naturalEarth1
		},
        mark={
            :geoshape,
            fill=:transparent,
            stroke=:gray
        },
        data={
            values=d,
            format={
                type=:topojson,
                features=:land
            }
        }
    ) 
end
=#


function cptopo(w = 900, h = 500)
    land10mfile = repo * "/data/land-10m.json"
    land10m = JSON.parsefile(land10mfile)
    d=VegaDatasets.VegaJSONDataset(land10m,land10mfile)

    @vlplot(width=w, height=h) +
    @vlplot(
        :geoshape,
        width=w, height=h,
        mark={
            :geoshape,
            fill=:transparent,
            stroke=:gray
        },
        data={
            values=d,
            format={
                type=:topojson,
                feature=:land
            }
        },
        projection={
            type=:naturalEarth1
        },
      
    )
end