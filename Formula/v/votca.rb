class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2024.2.tar.gz"
  sha256 "704d50f64bbfa2e19d0aa4b5726ac35c20c3b9b45554be5f1e1417d430e31c24"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aea5facda243f9a16190b7242f3532f8a7bd25662247d02745dc8c8399926ac0"
    sha256 cellar: :any,                 arm64_sonoma:  "402634e05ebfe58164b44caa0fc1cfaf0304e7451bd6c6a602a2d92825085a84"
    sha256 cellar: :any,                 arm64_ventura: "393682f25a17aff3505dde1fad7931c8e02c07f68ecafde5fce1f9b051fea444"
    sha256 cellar: :any,                 sonoma:        "6771d8aaab5999b1a57791a7268d27377d4e20fba0d6fe85c784fde7862c44ea"
    sha256 cellar: :any,                 ventura:       "491259224e0b3bc7c7d84ca71fdf04c498e75e26f0129e4dbbb1f63fb0332ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa59b1bc85966f998d5443fbd1dcd8d7abcd9a76c5fdc3d1eac1bd7cb6ece51f"
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
