class Qrupdate < Formula
  desc "Fast updates of QR and Cholesky decompositions"
  homepage "https://sourceforge.net/projects/qrupdate/"
  url "https://downloads.sourceforge.net/project/qrupdate/qrupdate/1.2/qrupdate-1.1.2.tar.gz"
  sha256 "e2a1c711dc8ebc418e21195833814cb2f84b878b90a2774365f0166402308e08"
  license "GPL-3.0-or-later"
  revision 15

  livecheck do
    url :stable
    regex(%r{url=.*?/qrupdate[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "883c11e84b2dcdd6ed46344697e8363a2c61e68d26aa6439d4684bc1a7abc76b"
    sha256 cellar: :any,                 arm64_monterey: "c8c154ece840edeeb4b4d0fe76383b60177ada3a525d96a124dc3fac80d9ae34"
    sha256 cellar: :any,                 arm64_big_sur:  "349ff7a34aacf021f8df3d129fa7e8897bd1b87a41d7df6b270fa98d73039ab4"
    sha256 cellar: :any,                 ventura:        "eae9333e11a79c651d8313e0b9c969c104a083edc3f6c835d484b10394f1f32b"
    sha256 cellar: :any,                 monterey:       "20e6d9ac347bc1903177aa5273e25ac2fd1f6dd56211e4170d46741ebdbd0b4d"
    sha256 cellar: :any,                 big_sur:        "12240dfe307818f58b11e495c81258979570e55640173382d3be77e39ee8dd0a"
    sha256 cellar: :any,                 catalina:       "b5a26e72c3d49e5b8b70432c11c93ffb392325c4a8a16cce2497b203bd23559d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf21846969fac2323ea2d8762b04c7f090bb0d9092c98636a853c50aaab49230"
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
