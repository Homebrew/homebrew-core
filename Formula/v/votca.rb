class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2024.tar.gz"
  sha256 "be1f8ad3de2ce86f0c01014aa5358c181f128a847bc4508ba0a4bffd5c82a1cf"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "504f8ab09074e72ba32a4a295445c25b69b72de16c1250887ce1992c59a56e09"
    sha256 cellar: :any,                 arm64_ventura:  "7531ab683d8456efbf5ad26e60cd6cbaa47247ca3978d1190c9c76ff5f4a9776"
    sha256 cellar: :any,                 arm64_monterey: "a8fe9612566ffc9523f848051bea9c34e7647b2f17c90376592e07dc63d33853"
    sha256 cellar: :any,                 sonoma:         "1f9259d2b6505d7024cef35bf0ac09b594820ae5d024a4afb418d42811f6e939"
    sha256 cellar: :any,                 ventura:        "d169ac530b6d8fbb309e75baa24d930b4cbb276fb35a7ddda479ec4cd93758fc"
    sha256 cellar: :any,                 monterey:       "d4a876cb84a7274acf864514c09e87cee8c1dfce0f6152b73f43619f23b4139e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5172837a798669038f93ed27dad0aec384bbb9f0179131e38b40c43f80f88905"
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

  # Backport fix for build failure with `boost` 1.85.0. Remove in the next release.
  patch do
    url "https://github.com/votca/votca/commit/9a29a3a82ea23c5159d43b0f25218601e12085b4.patch?full_index=1"
    sha256 "814fad24b533b84855f5171dda6789552872f16e1bbc3bebf8a3ebb2394440af"
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
