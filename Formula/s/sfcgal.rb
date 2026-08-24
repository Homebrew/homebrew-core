class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "https://sfcgal.gitlab.io/SFCGAL/"
  url "https://gitlab.com/sfcgal/SFCGAL/-/archive/v2.3.0/SFCGAL-v2.3.0.tar.gz"
  sha256 "5f6aa1838e5ae31523ebf410cde0240b7a88d7e062b7ffff945e4fae2aaba0fa"
  license "LGPL-2.0-or-later"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "db74c9aca42ddbe59b08e178673d939fe9f8a6ad5b6c88fa3f091fa31beeb30c"
    sha256 cellar: :any, arm64_sequoia: "5025298f7c948a1032271d10dab015ca661a2142573c005cfe89958c8d6f8454"
    sha256 cellar: :any, arm64_sonoma:  "a4b5d99028fbc0ce19aa4bbff6166c3472f5ec53e0e2b22747ca14b2535e9bd9"
    sha256 cellar: :any, sonoma:        "98d28a19be0ab74b4e81f3a32be12f392cb6a9dd995418a6a9a750b62f7f29b2"
    sha256 cellar: :any, arm64_linux:   "218dfcd3098a775a7308c5e6054ff31a1453b93bab71a82c3a151f12db53cb2a"
    sha256 cellar: :any, x86_64_linux:  "631f71a2b0cb80fa65a9f222ddff8cde1bb9096ee0b5df4cc765131e845414be"
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "nlohmann-json" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    # TODO: Drop SFCGAL_WITH_EIGEN=ON once SFCGAL enbles it when Eigen is detected
    # See: https://gitlab.com/sfcgal/SFCGAL/-/merge_requests/778
    system "cmake", "-S", ".", "-B", "build", "-DSFCGAL_WITH_EIGEN=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
