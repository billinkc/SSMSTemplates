-- Geometry data type
-- Flat earth
-- Open Geospatial Consortium OGC
DECLARE @geometry geometry 

SET @geometry = geometry::STGeomFromText('LINESTRING (100 100, 20 180, 180 180)', 0)
-- Look at the spatial results tab!
SELECT @geometry

-- scroll down to see more
SET @geometry = geometry::STGeomFromText('POLYGON((0 0, 3 0, 3 3, 0 3, 0 0),(2 2, 2 1, 1 1, 1 2, 2 2))', 0);
SELECT @geometry.STArea();
SELECT @geometry

-- Geometry & geospatial data types have 11 subtypes, 7 you can directly instantiate
-- Point
-- MultiPoint
-- LineString - A LineString is a one-dimensional object representing a sequence of points and the line segments connecting them. A LineString instance must be formed of at least two distinct points, and can also be empty
-- MultiLineString
-- Polygon
-- MultiPolygon
-- GeometryCollection

DECLARE @g geometry;
SET @g = geometry::STGeomFromText('LINESTRING(1 1 NULL 0, 2 4 NULL 12.3, 3 9 NULL 24.5)', 0);
SELECT @g


-- Types of spatial data
-- ms-help://MS.SQLCC.v10/MS.SQLSVR.v10.en/s10de_1devconc/html/1615db50-69de-4778-8be6-4e058c00ccd4.htm

-- geopgraphy data type
-- round earth

DECLARE @gp geography;
SET @gp = geography::STGeomFromText('LINESTRING(-122.360 47.656, -122.343 47.656)', 4326);
SELECT @gp

