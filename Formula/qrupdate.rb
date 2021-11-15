class Qrupdate < Formula
  desc "Fast updates of QR and Cholesky decompositions"
  homepage "https://sourceforge.net/projects/qrupdate/"
  url "https://downloads.sourceforge.net/project/qrupdate/qrupdate/1.2/qrupdate-1.1.2.tar.gz"
  sha256 "e2a1c711dc8ebc418e21195833814cb2f84b878b90a2774365f0166402308e08"
  revision 14

  livecheck do
    url :stable
    regex(%r{url=.*?/qrupdate[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_big_sur: "37f1e9c921973d004aa17330658a7e3b8eab48f8b0c3795aaf75acc36b0adad8"
    sha256 cellar: :any,                 monterey:      "7a0890711406e18b5cd4851abb3c83011a98766e93933c934fefade2beabb0fd"
    sha256 cellar: :any,                 big_sur:       "bf048deb2737ada46b63c53b36bfb39cc1ba536d810ef6daad38e21a949777f9"
    sha256 cellar: :any,                 catalina:      "ac9f87f4e27825031f0d15e097a6e1fd644fa0e6eac9e0f9e605c35c9e7c3ab6"
    sha256 cellar: :any,                 mojave:        "02ae54ea1999c2df3d37ed9f07af0f2a038e35d528432143951bb9a2062af619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f4e8ae6842fe139dfb889c7748d54660d9d30cb6b7c3314ab123e4270e34b82"
  end

  depends_on "gcc" # for gfortran
  depends_on "openblas"

  def install
    # Parallel compilation not supported. Reported on 2017-07-21 at
    # https://sourceforge.net/p/qrupdate/discussion/905477/thread/d8f9c7e5/
    ENV.deparallelize

    system "make", "lib", "solib",
                   "BLAS=-L#{Formula["openblas"].opt_lib} -lopenblas"

    # Confuses "make install" on case-insensitive filesystems
    rm "INSTALL"

    # BSD "install" does not understand GNU -D flag.
    # Create the parent directory ourselves.
    inreplace "src/Makefile", "install -D", "install"
    lib.mkpath

    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "test/tch1dn.f", "test/utils.f"
  end

  test do
    system "gfortran", "-o", "test", pkgshare/"tch1dn.f", pkgshare/"utils.f",
                       "-fallow-argument-mismatch",
                       "-L#{lib}", "-lqrupdate",
                       "-L#{Formula["openblas"].opt_lib}", "-lopenblas"
    assert_match "PASSED   4     FAILED   0", shell_output("./test")
  end
end
