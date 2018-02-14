class Qrupdate < Formula
  desc "Fast updates of QR and Cholesky decompositions"
  homepage "https://sourceforge.net/projects/qrupdate/"
  url "https://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz"
  sha256 "e2a1c711dc8ebc418e21195833814cb2f84b878b90a2774365f0166402308e08"
  revision 7

  bottle do
    cellar :any
    sha256 "840232d0b89e23401a97fab779ccc7ac4ebbe2084dab14885e84af782ae659bd" => :high_sierra
    sha256 "13e312d56e25a4c3af283a09c8e08cee22a4da677e16388d6cc65910a7086ad4" => :sierra
    sha256 "7615aa35c9399e47ee37a61a2431cde51c7976f1343e4bd85a55b1ea06075784" => :el_capitan
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
