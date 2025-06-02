class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "https://sfcgal.gitlab.io/SFCGAL/"
  url "https://gitlab.com/sfcgal/SFCGAL/-/archive/v2.1.0/SFCGAL-v2.1.0.tar.gz"
  sha256 "cb73a0496c61a5c7bf0ccc68c42e4378bfc441b242e9dee894067e24d2e21d0f"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a7b0727c269876eec4f2d4220b0f982d7c226eb88abacf424673f7d16a659a4e"
    sha256 cellar: :any,                 arm64_sonoma:  "f6e6c487463be6bef875dc78e278a276446d5f3c8c511d89b88364280a6130c2"
    sha256 cellar: :any,                 arm64_ventura: "a3e42c1c990f00fae52418a0239789d03358bde48902a98e30b9ba28470df6f0"
    sha256 cellar: :any,                 sonoma:        "d7c5ded8a7de47e7533b4f84978ae9897f155d966e9730ad989880422285bb6a"
    sha256 cellar: :any,                 ventura:       "93486bc9c6599461e48bc2e3afde3d9923b986a44e0405a1dd1af9f2793be4ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bddf5bf890c2df8cf195fb80b7bab394c939f637d204d845716fb80563639617"
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
