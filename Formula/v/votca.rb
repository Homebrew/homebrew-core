class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2025.tar.gz"
  sha256 "ee2ac59c858ee41ef3ecf636b263464cac5895c0ee9c8f97b1aafca4b8b76350"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0af8d4ac732328083b4365843fd5f7d9966ea3c0b2a93a877b14e8e98854f1fc"
    sha256 cellar: :any,                 arm64_sonoma:  "baf625629e92168a63d022d84a5294dba911fcae9d2a298928de919caa717153"
    sha256 cellar: :any,                 arm64_ventura: "bb31bdeab630d25406c7cc9aaaa40fbf70e1f72dc27b20b019cb50906d9250cc"
    sha256 cellar: :any,                 sonoma:        "48a5aa8396c13fbaebb120459d000b8cb818bf098633422624a4d339c0e5008d"
    sha256 cellar: :any,                 ventura:       "2c0c319154dda7c3069b2ec130eab480e0a0b4cfb9b32cb5e494cf90fc9492b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e78e7b95b50a037ca8a6a0967b832fb686ba0d53a6626ccad47ef58fea7bb23a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7787dfb6341cdb37688034916e679ecd798ce56fd332ae6163aa5b8528d8b75"
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
