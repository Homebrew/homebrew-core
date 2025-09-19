class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2025.tar.gz"
  sha256 "ee2ac59c858ee41ef3ecf636b263464cac5895c0ee9c8f97b1aafca4b8b76350"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "488ca9dcc8766483075398f032bb53dafd5d099a79733097fa4b9fcb5733a3ca"
    sha256 cellar: :any,                 arm64_sequoia: "49d06defa83fa836439a76328b45c47bd1b5d51a36a9b11588c136768406d5ed"
    sha256 cellar: :any,                 arm64_sonoma:  "347fe6f8d77363ff23180d1b57b8afe00e29a628df4e736d154dff4e53609ad0"
    sha256 cellar: :any,                 arm64_ventura: "908abe750c2a90c342c4b25d54f13cb0dd17de2969ea8fc33c5f53cfb96b2ab7"
    sha256 cellar: :any,                 sonoma:        "977de90ad8d326d316bd95a09180d6fdf2614a2bfb961b3434be02cca404cbdc"
    sha256 cellar: :any,                 ventura:       "8899fd469c58e43781e37c33ab8879a0c033d9751c6231983fbab2e2c669e122"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8d8668f5c90d2cdf59790ac441e86a2517241d81772966bd66874e21b6c720d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bbaa9113e6ed96c12a2fab7442a138ad601c7d8ec52ce07b2cf85fa893463e4"
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

  # Fix build with Boost 1.89.0, pr ref: https://github.com/votca/votca/pull/1183
  patch do
    url "https://github.com/votca/votca/commit/427352421ac0b541805d383ebecad2bfc37957d1.patch?full_index=1"
    sha256 "489583bd951d9395a80b872c2889eddd588f819708244a7dab017f02a99c0a68"
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
