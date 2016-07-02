class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.0.tar.gz"
  sha256 "7ed35439fc197e73790f4c3d1c1750acdc3044968769239b2185a7a845845df3"

  bottle do
    sha256 "cddb259f1fdc03ba213c56757485efee012acf10c96f39af7387ee40b4901f8e" => :el_capitan
    sha256 "65c06ed4853d2179793da87bebd78c3b025cb8b2437e41dd40f247f9a322a656" => :yosemite
    sha256 "6512802b7da2f59d1a449dda91d15537be24814bee913ca73c68ccd7082f1d9e" => :mavericks
  end

  option :cxx11

  depends_on "cmake" => :build
  depends_on "mpfr"
  if build.cxx11?
    depends_on "boost" => "c++11"
    depends_on "cgal" => "c++11"
    depends_on "gmp"   => "c++11"
  else
    depends_on "boost"
    depends_on "cgal"
    depends_on "gmp"
  end

  def install
    ENV.cxx11 if build.cxx11?
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
