class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2024.tar.gz"
  sha256 "be1f8ad3de2ce86f0c01014aa5358c181f128a847bc4508ba0a4bffd5c82a1cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e2e3a40552fadfa8ffa3a77d9b1d576cc5ed08a612d68f1deb243bd75243920c"
    sha256 cellar: :any,                 arm64_ventura:  "babea6dd9efd0f7054824574b4928ab90465ebfe3e19665549b261e3ae751f77"
    sha256 cellar: :any,                 arm64_monterey: "72c428f3969178b880ef91f5065587f51364e4759c9f544f9a6a7ee67e3fac55"
    sha256 cellar: :any,                 sonoma:         "77fdbfc8c5ebef2b76e48877050cf2a31890ed38d79d9c44ac95bc11f9fd563e"
    sha256 cellar: :any,                 ventura:        "e13acc662e9c9937cee863a5f9b6d8f2a6b13098214051c6ff3c26c98c155daf"
    sha256 cellar: :any,                 monterey:       "d8c30282c82d610ea4f5dc9800255362b1255cdc79520ec233d10c5c946f5489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a4af40cd6d4fc75ba1e20a141f943c52f304fc89907f2686c2ca9d7b7b6ad0a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  # add gromacs dep back once it was built with clang
  # Use hdf5@1.10: Unable to determine HDF5 CXX flags from HDF5 wrapper.
  depends_on "hdf5@1.10"
  depends_on "libecpint"
  depends_on "libint"
  depends_on "libxc"
  depends_on "numpy"
  depends_on "python@3.12"

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
