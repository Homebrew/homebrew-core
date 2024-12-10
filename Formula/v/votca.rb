class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2024.2.tar.gz"
  sha256 "704d50f64bbfa2e19d0aa4b5726ac35c20c3b9b45554be5f1e1417d430e31c24"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "3bee35e3501b30d45351535d5df50f4529b6db11d024df9b48d0e1d712edd626"
    sha256 cellar: :any,                 arm64_sonoma:  "6f4e7335acbdcae62e289c13f25384583a9073b7304839627115b44948f3e3b4"
    sha256 cellar: :any,                 arm64_ventura: "0bb72aea264b3b63efcbb022883c5870ba5517b3bd9790ea15ed9e78118ad05d"
    sha256 cellar: :any,                 sonoma:        "8795bb4558db3b7744dd1383681d53718476a22974368a1ea3ca06d818e0baa8"
    sha256 cellar: :any,                 ventura:       "4fdb6152fdedf5e0dd7971fa9b5646c6a915874333f6946739520a86edd41316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a263fe3977df21e1d8033c82270ffa20c86d4dda43393f7ca728699599dcb23"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  # add gromacs dep back once it was built with clang
  depends_on "hdf5"
  depends_on "libecpint"
  depends_on "libint"
  depends_on "libxc"
  depends_on "numpy"
  depends_on "python@3.13"

  uses_from_macos "expat"

  on_macos do
    depends_on "libaec"
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
    system bin/"csg_property", "--help"
    (testpath/"table.in").write <<~EOS
      0 0 i
      1 1 i
    EOS
    system bin/"csg_resample", "--in", "table.in", "--out", "table.out", "--grid", "0:0.1:1", "--type", "linear"
    assert_path_exists "#{testpath}/table.out"
  end
end
