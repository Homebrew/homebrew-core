class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.4.1/SFCGAL-v1.4.1.tar.gz"
  sha256 "1800c8a26241588f11cddcf433049e9b9aea902e923414d2ecef33a3295626c3"
  license "LGPL-2.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "02b4121d8d7ea923e879dab8a93fd4039127c036edb5c192f744da0197386eaa"
    sha256 cellar: :any,                 arm64_monterey: "4153f69b3ef306d23ed9d4619c9d38b253179caf52b0a208678795c6dacdd4fc"
    sha256 cellar: :any,                 arm64_big_sur:  "428f6abdaab0d531c518f7781a6c1eef8764be9565a51f677dcb4a850489ebbe"
    sha256 cellar: :any,                 ventura:        "3621f7ffb66ecbfd8d0293c5c002a10faec05507b083af6ded4f2d31ca084532"
    sha256 cellar: :any,                 monterey:       "935fd461fcbf1570394f454b920a9ba443a32d092e85f659ee42d6241d8ee768"
    sha256 cellar: :any,                 big_sur:        "513a796ef52c1f5c72312ec0aade227d33a06fadb7844f5c14ba63560f9f8441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08541be2cb505a3c32fb99269f19e2eb98f22575933bc62fb2e2aa915b78b536"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  # error: array must be initialized with a brace-enclosed initializer
  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
