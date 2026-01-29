class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2025.1.tar.gz"
  sha256 "85b487d2b2a31f26869be422c98f816b95c88a4ab112ea4650cccd4c2706bdbf"
  license "Apache-2.0"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ebedfd7a8f4a4a958f45c48b33f78d03e6689f90b0a5d1ab604adf7cece29ac1"
    sha256 cellar: :any,                 arm64_sequoia: "4a1ccb8ae3de07ee243281f08d476a76aeff2ba65c2d4eaa1efd3576c4214d91"
    sha256 cellar: :any,                 arm64_sonoma:  "2a18f6145466daa3bed03fc6bfdec3b0930612342708cb14c3d1701681033dc9"
    sha256 cellar: :any,                 sonoma:        "caec123f9f6ddad1fcbdfacfcbf5d7d284d61f0c7f52f727c51b626c6d93021b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cf0d5b39648c54d4f6aca3f671d56d4f58e2f4a6ec62db9ad28ae6983c40b71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f75816e6fe38c61a7b2647e1dcb40f856b39f92c12b0be29e33f20c7b0031fe2"
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
