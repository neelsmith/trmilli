
lazy val scala211 = "2.11.12"
lazy val scala212 = "2.12.10"
lazy val supportedScalaVersions = List(scala212, scala211)

ThisBuild / scalaVersion := scala212
ThisBuild / turbo := true

lazy val root = (project in file("."))
  .settings(
  resolvers += Resolver.jcenterRepo,
  resolvers += Resolver.bintrayRepo("neelsmith", "maven"),
  libraryDependencies ++= Seq(
    "org.scalatest" %% "scalatest" % "3.1.2" % "test",
    "org.wvlet.airframe" %% "airframe-log" % "20.5.2",
    "edu.holycross.shot.cite" %% "xcite" % "4.3.0",
    "edu.holycross.shot" %% "ohco2" % "10.20.4",
  )
)
