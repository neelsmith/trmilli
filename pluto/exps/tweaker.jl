# Play with params for framing Lycian map

projt = :naturalEarth1

function plotgrat( rot1, rot2, rot3, proj = projt, w = 600, h = 300)
	
		
    @vlplot(width=w, height=h) +
	
    @vlplot(
        projection={
			type=proj,
			rotate=[rot1,rot2,rot3]
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
    :circle,
    data=lls,
    longitude="lon:q",
    latitude="lat:q",
    color={value=:aliceblue}
)  +
	
	@vlplot(
		 mark={
            :geoshape,
            fill=:transparent,
            stroke=:red
        },
		data={
            values=world110m,
            format={
                type=:topojson,
                feature=:land
            }
		}
		)
	
end
