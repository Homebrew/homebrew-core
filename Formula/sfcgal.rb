class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.5.tar.gz"
  sha256 "e36937d1d8421134c601e80a42bd535b1d9d7e7dd5bdf4da355e58942ba56006"

  bottle do
    rebuild 1
    sha256 "6e8a77c5d417be558ae8dfe8fa33072b304824c04a9e4c9f34d187390a5c4a36" => :mojave
    sha256 "82b7ce5b5d88e97904c8703369b65695ec85d40e707ff5ded54323db21d12f33" => :high_sierra
    sha256 "094eaf42f6123d2927cf34b319488e23894f1f893cba538588ec3c31472ec9b9" => :sierra
    sha256 "74079eb2c55b0951bddec3546b14230da45789229a3e745d2c06d0a3c49d2f5e" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  # These two upstream commits fix build failures with CGAL 4.12.
  # Remove with next version.
  # https://github.com/Oslandia/SFCGAL/pull/168
  patch do
    url "https://github.com/Oslandia/SFCGAL/commit/e47828f7.diff?full_index=1"
    sha256 "5ce8b251a73f9a2f1803ca5d8a455007baedf1a2b278a2d3465af9955d79c09e"
  end

  # https://github.com/Oslandia/SFCGAL/pull/169
  patch do
    url "https://github.com/Oslandia/SFCGAL/commit/2ef10f25.diff?full_index=1"
    sha256 "bc53ce8405b0400d8c37af7837a945dfd96d73cd4a876114f48441fbaeb9d96d"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
