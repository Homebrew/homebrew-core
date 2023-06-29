class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2022.1.tar.gz"
  sha256 "4710a7552f94789936324d76d2e0830b576de8d3f1c605748e2d20947d018100"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e5280df285ba79120a1960cec2ac51ce3b6f2b8e7cb897d3fa5b7279a29b1cc2"
    sha256 cellar: :any,                 arm64_monterey: "ac1de2b7d41c4e2c1802950e9b0159abf6cad403e4f7ff8e634945a7db2b231d"
    sha256 cellar: :any,                 arm64_big_sur:  "28a697e0c95462ee389b2430dfd1101a5edd5a41e7e4d2d091fb8ae0b6b4d310"
    sha256 cellar: :any,                 ventura:        "75f0fbb2f252b0cd492a4cc6964edf57695560184f8addd8c993004ab93f500c"
    sha256 cellar: :any,                 monterey:       "5af769baa50f40ccb3a5c849e3bf84072e7fc99df7c8cb6e69cbf611db663075"
    sha256 cellar: :any,                 big_sur:        "7e91a6b9b6665f336b5b084cf99f5acba39aba8f6429a0cd58cdb5204d5ccccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eb2e5b2942225b77321b004302050b9ca8ca14f73c12b7a00f44bf0759cdd53"
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
