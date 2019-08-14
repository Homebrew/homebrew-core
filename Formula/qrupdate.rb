class Qrupdate < Formula
  desc "Fast updates of QR and Cholesky decompositions"
  homepage "https://sourceforge.net/projects/qrupdate/"
  url "https://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz"
  sha256 "e2a1c711dc8ebc418e21195833814cb2f84b878b90a2774365f0166402308e08"
  revision 11

  bottle do
    cellar :any
    sha256 "cbaca0a12ab0f6527739e37a9100b82e3aaa5b35760739e679395dbfd63dca44" => :mojave
    sha256 "fee484380157553a368f516ad9b8cbe01be53bca3bd20068a0d255c33d8ccf94" => :high_sierra
    sha256 "2e7760a64f95a7243f0ac9dfc85be775943b40b462c00c7fc25241ea2b2eef36" => :sierra
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
                       "-L#{lib}", "-lqrupdate",
                       "-L#{Formula["openblas"].opt_lib}", "-lopenblas"
    assert_match "PASSED   4     FAILED   0", shell_output("./test")
  end
end
