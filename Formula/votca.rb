class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2022.1.tar.gz"
  sha256 "4710a7552f94789936324d76d2e0830b576de8d3f1c605748e2d20947d018100"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "da7266fac5df3301435b6d8d3be146ac5cc13806283eb1ef97b63ca51440d016"
    sha256 cellar: :any,                 arm64_monterey: "81b8dcb3765fc378847f6c71a0c0df5c85c3bc92daae12ada03520e0b0a4c7e5"
    sha256 cellar: :any,                 arm64_big_sur:  "522f72f060f854a3623cb3f882e56c9b29b5e69a65bfc1df7faea26ba3e49fef"
    sha256 cellar: :any,                 ventura:        "ee0d6a62064f0509481f4b6e6e24303e91d65d3589631af0dad3c049b606b3e6"
    sha256 cellar: :any,                 monterey:       "9a98e188bfb8a78436893c7d6143ab927deb8253b25edeb0b88d381994f54aad"
    sha256 cellar: :any,                 big_sur:        "0a3e8d97911b6800408237a03b67c98a94898fbc208c3eb2c9e674bb38a95d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2204dd5e27aea832f7d2f5c658c42ed190750447a89157cf45985824f11a07cb"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  # add gromacs back once it was built with clang
  depends_on "hdf5"
  depends_on "python@3.11"

  uses_from_macos "expat"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = [
      "-DINSTALL_RC_FILES=OFF",
      "-DINSTALL_CSGAPPS=ON",
      "-DBUILD_XTP=OFF",
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
