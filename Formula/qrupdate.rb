class Qrupdate < Formula
  desc "Fast updates of QR and Cholesky decompositions"
  homepage "https://sourceforge.net/projects/qrupdate/"
  url "https://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz"
  sha256 "e2a1c711dc8ebc418e21195833814cb2f84b878b90a2774365f0166402308e08"
  revision 7

  bottle do
    cellar :any
    sha256 "cc98f58515cad95967f6ef0ec7e7dd6b7a00b0365f465c05d04c8b2d3908dd96" => :high_sierra
    sha256 "6ed6531659001d949538c70ccfc4380b7cfaa4cae7be40947baba1cce596c005" => :sierra
    sha256 "00f285ea5819d6dc6b5000c835b9b12da725c5a4c7e8049368581e7071fa087d" => :el_capitan
    sha256 "773cb82bd7665e6948ca0a3d9dae7d2bcaf79c384b219a6bc1de5b0451e1d876" => :yosemite
  end

  depends_on "gcc" # for gfortran
  depends_on "veclibfort"

  def install
    # Parallel compilation not supported. Reported on 2017-07-21 at
    # https://sourceforge.net/p/qrupdate/discussion/905477/thread/d8f9c7e5/
    ENV.deparallelize

    system "make", "lib", "solib",
                   "BLAS=-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"

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
                       "-L#{lib}", "-lqrupdate", "-lvecLibFort"
    assert_match "PASSED   4     FAILED   0", shell_output("./test")
  end
end
