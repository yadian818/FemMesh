# This file is part of FemMesh package. See copyright license in https://github.com/NumSoftware/FemMesh

# Point
# =====
"""
A geometry type that represents a coordinate point.
"""
mutable struct Point
    x    ::Float64
    y    ::Float64
    z    ::Float64
    tag  ::TagType
    id   ::Int64
    function Point(x::Real, y::Real, z::Real=0.0, tag::TagType=0)
        NDIG = 14
        # zero is added to avoid negative bit sign for zero signed values
        x += 0.0
        y += 0.0
        z += 0.0
        #x = round(x, digits=NDIG) + 0.0
        #y = round(y, digits=NDIG) + 0.0
        #z = round(z, digits=NDIG) + 0.0
        return new(x, y, z, tag,-1)
    end
    function Point(C::AbstractArray{<:Real}; tag=0)
        # zero is added to avoid negative bit sign for zero signed values
        if length(C)==2
            return new(C[1]+0.0, C[2]+0.0, 0.0, tag, -1)
        else
            return new(C[1]+0.0, C[2]+0.0, C[3]+0.0, tag, -1)
        end
    end
end


### Point methods

Base.copy(point::Point) = Point(point.x, point.y, point.z, point.tag)
Base.copy(points::Array{Point,1}) = [ copy(p) for p in points ]

# The functions below can be used in conjuntion with sort
get_x(point::Point) = point.x
get_y(point::Point) = point.y
get_z(point::Point) = point.z

#Base.hash(p::Point) = floor(UInt, abs(1000000 + p.x*1001 + p.y*10000001 + p.z*100000000001))
#Base.hash(p::Point) = hash( (p.x==0.0?0.0:p.x, p.y==0.0?0.0:p.y, p.z==0.0?0.0:p.z) ) # comparisons used to avoid signed zero
#Base.hash(p::Point) = hash( (p.x==0.0?0.0:p.x, p.y==0.0?0.0:p.y, p.z==0.0?0.0:p.z) ) # comparisons used to avoid signed zero

Base.hash(p::Point) = hash( (round(p.x, digits=8), round(p.y, digits=8), round(p.z, digits=8)) ) 
#Base.hash(p::Point) = hash( (p.x, p.y, p.z))

Base.hash(points::Array{Point,1}) = sum(hash(p) for p in points)

Base.:(==)(p1::Point, p2::Point) = hash(p1)==hash(p2)

getcoords(p::Point) = [p.x, p.y, p.z]

# Sentinel instance for not found point
const NO_POINT = Point(1e+308, 1e+308, 1e+308)

function get_point(points::Dict{UInt64,Point}, C::AbstractArray{<:Real})
    hs = hash(Point(C))
    return get(points, hs, nothing)
end

function getcoords(points::Array{Point,1}, ndim::Int64=3)
    np = length(points)
    C  = Array{Float64}(undef, np, ndim)
    for i=1:np
        C[i,1] = points[i].x
        C[i,2] = points[i].y
        ndim>2 && (C[i,3] = points[i].z)
    end

    return C
end

function setcoords!(points::Array{Point,1}, coords::AbstractArray{Float64,2})
    nrows, ncols = size(coords)
    np = length(points)
    @assert np==nrows

    for (i,p) in enumerate(points)
        p.x = coords[i,1]
        p.y = coords[i,2]
        ncols==3 && (p.z = coords[i,3])
    end
end

