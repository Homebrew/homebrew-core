class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2022.1.tar.gz"
  sha256 "4710a7552f94789936324d76d2e0830b576de8d3f1c605748e2d20947d018100"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "04b9715c8b76a72d8996a0f6265a905b17b7ddeca633f7dce4d0ee0ca446d408"
    sha256 cellar: :any,                 arm64_ventura:  "ad34a8fdf13c83d4cf4ed6ee1aad28bb6161f4cc438f81b340cecfb4ac5c7ed3"
    sha256 cellar: :any,                 arm64_monterey: "0784db80c5bc27862a3ba49f00d62c805ec18744261639e396886eae1b49f555"
    sha256 cellar: :any,                 arm64_big_sur:  "5fab23c3eaaddf5f2925d59faa696892bc87cd6a9e8773d0e15ede3888b5a798"
    sha256 cellar: :any,                 sonoma:         "0991d9164ab91fd31635efc7358a4082da329720d5557a25532779b0c74d67d7"
    sha256 cellar: :any,                 ventura:        "ea91a1fb5731bd55db8c3fe18fcfa9ac960123b467b5e584ee74e1122310da42"
    sha256 cellar: :any,                 monterey:       "42ec271c4ae0624818a3d0b121c64e7fb51bc1aaee27ac967e56579d7b5f9346"
    sha256 cellar: :any,                 big_sur:        "ec1350082099bef7701d08a0c9015f900a356bbe97c3d907cec9b28f0313a020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2acf1dbc9533e8d317ff5215f37f3a336177d6b28f30718c335c6dafb954847f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  # add gromacs dep back once it was built with clang
  depends_on "hdf5"
  depends_on "libecpint"
  depends_on "libint"
  depends_on "libxc"
  depends_on "python@3.11"

  uses_from_macos "expat"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = [
      "-DINSTALL_RC_FILES=OFF",
      "-DINSTALL_CSGAPPS=ON",
      "-DBUILD_XTP=ON",
      "-DCMAKE_DISABLE_FIND_PACKAGE_GROMACS=ON",
      "-DENABLE_RPATH_INJECT=ON",
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/csg_property", "--help"
    (testpath/"table.in").write <<~EOS
      0 0 i
      1 1 i
    EOS
    system "#{bin}/csg_resample", "--in", "table.in", "--out", "table.out", "--grid", "0:0.1:1", "--type", "linear"
    assert_path_exists "#{testpath}/table.out"
  end
end
