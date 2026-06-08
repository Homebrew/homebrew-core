class Wfa2Lib < Formula
  desc "Wavefront alignment algorithm library v2"
  homepage "https://github.com/smarco/WFA2-lib"
  url "https://github.com/smarco/WFA2-lib/archive/refs/tags/v2.3.6.tar.gz"
  sha256 "fd74c4bfdd5764ae8668cdeee7a80bfa35583b1980e261daa9dbf425bf12bb0b"
  license "MIT"
  head "https://github.com/smarco/WFA2-lib.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d34f0af8f0ea0c1aaebbf9d2323016c94ade299e5c0cfc2751944c4daafa2034"
    sha256 cellar: :any,                 arm64_sequoia: "3efa6e5cc18a0586e08c8a841501d638d13ef5a6ea11cb97eb441307f391855a"
    sha256 cellar: :any,                 arm64_sonoma:  "9e12eeb6572b88fa62264d561e14abe34e02eee12945991492479d3fae3a1efd"
    sha256 cellar: :any,                 sonoma:        "af478289bfe51ecdf40158ac6c780660b63c1837f451665517bc042296690baa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d54a15b0df4a1fb66c99ee1c65778e0261b1cbd71999ea4c1069f5fba66109ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f5b02177c40379b0e0de12a31d54779bf069223c49984ca04102a062421806d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", "-DOPENMP=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    system ENV.cc, pkgshare/"examples/wfa_basic.c", "-o", "test", "-I#{include}/wfa2lib", "-L#{lib}", "-lwfa2", "-lm"
    assert_match "WFA-Alignment returns score -24", shell_output("./test 2>&1")
  end
end
