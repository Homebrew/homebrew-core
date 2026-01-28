class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2025.1.tar.gz"
  sha256 "85b487d2b2a31f26869be422c98f816b95c88a4ab112ea4650cccd4c2706bdbf"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "067055a10061071812d04bda29a0730da6e743fa6a9ec932ce18b4e4af5e9e57"
    sha256 cellar: :any,                 arm64_sequoia: "86797174e26f6397651832504cb2ab99fda48280306843842f42afe455e94376"
    sha256 cellar: :any,                 arm64_sonoma:  "b0580e45b89242251411af42e05d1bd95b59ac2c13d93e5febe0bccb36de51a5"
    sha256 cellar: :any,                 sonoma:        "ead1dce31be6f1f57e960091c5dd09abbea1b792f158f2d8bf3a6ddeed2e26a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04b5af079dcacba0b47bfdad2b1ffb470f44a367fcb64040e087c6159f8a22c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0f1100d6640b0dd64ed6479fd8a19338dd179f299af5e808ed39e873d1e39fe"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "boost"
  depends_on "eigen" => :no_linkage
  depends_on "fftw"
  depends_on "gromacs"
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
