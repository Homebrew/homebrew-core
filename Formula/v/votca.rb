class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2025.1.tar.gz"
  sha256 "85b487d2b2a31f26869be422c98f816b95c88a4ab112ea4650cccd4c2706bdbf"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9083467e1a30e21f131314a426f6654540d04db6687629018552ebcf1de529b2"
    sha256 cellar: :any,                 arm64_sequoia: "82ca8b75d12568511c38bba54efd2bf120489431187a9704791d14f429ef2ba1"
    sha256 cellar: :any,                 arm64_sonoma:  "8ded162b5fbf26c6f586a6f973d1661317d238fba21fc7fbad0d3e1de4179341"
    sha256 cellar: :any,                 sonoma:        "49c3aef63077a07399971c5cda155542ec2cc6799231f74152e283022da9522a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27cc5ddb6f732c334b6d6536fdc76dfbf1198a5405187b126b073721ac4a618f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfecc869d913c683b8c37710fa4d5342e6e595873542fa0553c5d743304169db"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
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

  # Apply open PR to support eigen 5.0.0
  # PR ref: https://github.com/votca/votca/pull/1189
  patch do
    url "https://github.com/votca/votca/commit/cc581d91196c3505c649e35ba69bcc8ec33fa14b.patch?full_index=1"
    sha256 "08da2d4fd694eb1b3909fe4ef452b042a0b0733ca5d8b68e0e655b09842cb069"
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
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
