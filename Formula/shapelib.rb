class Shapelib < Formula
  desc "Library for reading and writing ArcView Shapefiles"
  homepage "http://shapelib.maptools.org/"
  url "https://download.osgeo.org/shapelib/shapelib-1.4.1.tar.gz"
  sha256 "a4c94817365761a3a4c21bb3ca1c680a6bdfd3edd61df9fdd291d3e7645923b3"

  bottle do
    cellar :any
    sha256 "421ca3047acf77e98015b15af2d1b22090a65e464ad2a773ccb725b7b56b1005" => :mojave
    sha256 "cdc9cc715cc716357b9faa701b930117e85b13e89a940ad6dbd6413af6308384" => :high_sierra
    sha256 "dd4f69f0833e460653959dee684d687bc2186031c5f7481dc5b6d3bc0f383e59" => :sierra
    sha256 "5ec5a7f6ae4857b2b43bdbcc360558e4f90ca6e510b42edd3ac5961988db195e" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "shp_file", shell_output("#{bin}/shptreedump", 1)
  end
end
