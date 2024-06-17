class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "https://sfcgal.gitlab.io/SFCGAL/"
  url "https://gitlab.com/sfcgal/SFCGAL/-/archive/v1.5.1/SFCGAL-v1.5.1.tar.gz"
  sha256 "ea5d1662fada7de715ad564dc810c3059024ed81ae393f5352489f706fdfa3b1"
  license "LGPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ffa4d1bb599bf2a6960411bb19c9fc8c4136ce8bbeb0b841e905ab966a107fe1"
    sha256 cellar: :any,                 arm64_ventura:  "30dd23a618d69e0769549af0cd2c157957ff71e8f4d044937b6b9bcd3721bf47"
    sha256 cellar: :any,                 arm64_monterey: "dabc44df168eda5b08cad5856ff0dbca4ba3a22bd64519dac79220181aa5a2c8"
    sha256 cellar: :any,                 sonoma:         "51f6f3f46b34a93cdf16c844d0be99796538f8993add9f803fb0c3f986c5b5b3"
    sha256 cellar: :any,                 ventura:        "eaaf02d44bbfafe4cb9d48c53a47474db7e7cc3a16ddefc764b3322065b8a9eb"
    sha256 cellar: :any,                 monterey:       "138ec5e064ef30ea47dd1a3f11060fe46f32fd27aa913c62ed3f90fc3a85cce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f36d0bbea3c7a2d02ffc0637de10d9140faaae4c418fd14c0810e9fca8560f6"
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
