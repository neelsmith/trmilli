
us10m = dataset("us-10m")
capitals = dataset("us-state-capitals")

function viewglobal()
    @vlplot(width=300, height=150) +
    @vlplot(
        projection={typ=:mercator},
        mark={
            :geoshape,
            fill=:lightgray,
            stroke=:white
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


function plotStateCaps()
    @vlplot(width=800, height=500) +
    @vlplot(
        mark={
            :geoshape,
            fill=:lightgray,
            stroke=:white
        },
        data={
            values=us10m,
            format={
                type=:topojson,
                feature=:states
            }
        },
        projection={type=:albersUsa},
    ) +
    @vlplot(
        :circle,
        data=capitals,
        longitude="lon:q",
        latitude="lat:q",
        color={value=:orange}
    ) +
    @vlplot(
        mark={
            type=:text,
            dy=-10
        },
        data=capitals,
        longitude="lon:q",
        latitude="lat:q",
        text={
            field=:city,
            type=:nominal
        }
    )
end