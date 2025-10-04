class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2025.1.tar.gz"
  sha256 "85b487d2b2a31f26869be422c98f816b95c88a4ab112ea4650cccd4c2706bdbf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "88602abcffa24d80a153c5c1463fcf7ed609e06d6f321a901993034d9a0ccd35"
    sha256 cellar: :any,                 arm64_sequoia: "54c2de88fd8da7adc51cf1ff4fee9a4155f25a20e7c3184cbb18036362bb340f"
    sha256 cellar: :any,                 arm64_sonoma:  "7a9c2b5109910aad26a8d1294a3bcdd63dad330f2e136f2ab339e58414838d8d"
    sha256 cellar: :any,                 sonoma:        "6cc2671cca6ddb98e642b941523c017c20468c59e31d983bfb1d8fac5f1c6e3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "479e6d8ea7651109c558f90220b609e566ae2388b56beabb0e4b6a6711b2960c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38fad623e875dd3a1016fb85971815877d0529044cb5b81b7aa90ba11684b7f1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "fftw"
  # add gromacs dep back once it was built with clang
  depends_on "hdf5"
  depends_on "libecpint"
  depends_on "libint"
  depends_on "libxc"

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
      "-DPYrdkit_FOUND=OFF",
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
