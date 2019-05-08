class Qrupdate < Formula
  desc "Fast updates of QR and Cholesky decompositions"
  homepage "https://sourceforge.net/projects/qrupdate/"
  url "https://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz"
  sha256 "e2a1c711dc8ebc418e21195833814cb2f84b878b90a2774365f0166402308e08"
  revision 9

  bottle do
    cellar :any
    sha256 "16fc7829c3154593813d8087d222a8e081f78afc90a508521022b0835b954978" => :mojave
    sha256 "c0f02275cee5d373ef3462afdaa0798a38bdea058e5c23b6ea0f3e87f0d95fc7" => :high_sierra
    sha256 "0aeaf652b412ba913a8f98e37a32f90544185122ccc9b885ec1e6003c60f56ab" => :sierra
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
                       "-L#{lib}", "-lqrupdate",
                       "-L#{Formula["veclibfort"].opt_lib}", "-lvecLibFort"
    assert_match "PASSED   4     FAILED   0", shell_output("./test")
  end
end
