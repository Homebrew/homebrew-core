class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "https://sfcgal.gitlab.io/SFCGAL/"
  url "https://gitlab.com/sfcgal/SFCGAL/-/archive/v2.0.0/SFCGAL-v2.0.0.tar.gz"
  sha256 "11843953f49e7e4432c42fd27d54e1ff7ca55d0cc72507725c2a5d840c2c6535"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7f0234c24f1574be350718dad2f1612124f90631a34d2161f950eff8fad4d808"
    sha256 cellar: :any,                 arm64_sonoma:  "387e36ad36d122b0aa717bdd99e93c255e61635713f58952d2e2df127f9a6047"
    sha256 cellar: :any,                 arm64_ventura: "181bfdebb902c3ba670822d6daf26ea65f4f5650989a0e0fb84ca40bfe2e83d2"
    sha256 cellar: :any,                 sonoma:        "b7d0fb782537f604f54a3c822bf92153287cde911b2358bd8662e314b375e873"
    sha256 cellar: :any,                 ventura:       "f11493b60f86dbc38b954a8268558d7906799be6067256b36618366bf71ecd43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "009288471a8e2969d49f20270ea842e90a1af155bc71b3106e338f27c3403d65"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
