class Qrupdate < Formula
  desc "Fast updates of QR and Cholesky decompositions"
  homepage "https://sourceforge.net/projects/qrupdate/"
  url "https://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz"
  sha256 "e2a1c711dc8ebc418e21195833814cb2f84b878b90a2774365f0166402308e08"
  revision 8

  bottle do
    cellar :any
    sha256 "3e9beaab01eb493f63fd2e472397423bdb6eb4da9ad21d77142450823b971ffa" => :mojave
    sha256 "b5f9fcfd7ddaca8e64b8b200bd413588a7fe608b31b7d1b9a23be53a2084bd3a" => :high_sierra
    sha256 "f1213f270e9c6a84e8c1707d3b956e7bb2a6670f53bbf405cdba4d8da2393846" => :sierra
    sha256 "c84f04635d00f139bcc5114b36395e7347c675ccb10fbf88a1779de5c6816c3a" => :el_capitan
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
