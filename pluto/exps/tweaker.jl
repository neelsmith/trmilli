# Play with params for framing Lycian map

projt = :naturalEarth1

function plotgrat(rot1=-30, rot2=-37, rot3=0; proj = projt, w = 600, h = 300, scalefactor = 7200)
	
		
    @vlplot(width=w, height=h) +
	
    @vlplot(
        projection={
			type=proj,
			rotate=[rot1,rot2,rot3],
            scale=scalefactor
		},
        mark={
            :geoshape,
            fill=:transparent,
            stroke=:gray
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
        projection={
			type=proj,
			rotate=[rot1,rot2,rot3],
            scale=scalefactor
		},
		 mark={
            :geoshape,
            fill=:lightgray,
            stroke=:transparent
        },
		data={
            values=world110m,
            format={
                type=:topojson,
                feature=:land
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
