class Qrupdate < Formula
  desc "Fast updates of QR and Cholesky decompositions"
  homepage "https://sourceforge.net/projects/qrupdate/"
  url "https://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz"
  sha256 "e2a1c711dc8ebc418e21195833814cb2f84b878b90a2774365f0166402308e08"
  revision 6

  bottle do
    cellar :any
    sha256 "797a5f20ea8a61b1c71588b5ccce081daf479239df9e8ac587f52134e3ee2685" => :sierra
    sha256 "5376220c35da94d8f1162dc34624a051fc415363046978f6788678b35af13813" => :el_capitan
    sha256 "2b527726bd3303edc9712e3e47b672a266cbb8065b4e41c51951746f2da8c08d" => :yosemite
  end

  depends_on :fortran
  depends_on "veclibfort"

  def install
    # Parallel compilation not supported. Reported on 2017-07-21 at
    # https://sourceforge.net/p/qrupdate/discussion/905477/thread/d8f9c7e5/
    ENV.deparallelize

    system "make", "lib", "solib", "FC=#{ENV.fc}",
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
    ENV.fortran
    system ENV.fc, "-o", "test", pkgshare/"tch1dn.f", pkgshare/"utils.f",
                   "-L#{lib}", "-lqrupdate", "-lvecLibFort"
    assert_match "PASSED   4     FAILED   0", shell_output("./test")
  end
end
