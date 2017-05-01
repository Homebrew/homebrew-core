class SrtpAT15 < Formula
  desc "Implementation of the Secure Real-time Transport Protocol (SRTP)"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v1.5.4.tar.gz"
  sha256 "56a7b521c25134f48faff26b0b1e3d4378a14986a2d3d7bc6fefb48987304ff0"

  bottle do
    cellar :any
    sha256 "e7342989d32260ecd2ba2010dbf54b6efc72466c13168f310f90a67c4300aa40" => :sierra
    sha256 "ee4a921ed6fe35f7a56fe4173e5632cbd8fc7cac78cd93050c2a6687ac3a59d2" => :el_capitan
    sha256 "471ee22eb25ecdef32f5f0a3bb9d1d68f32b2b3081611f38e9bc4a6522dfac3d" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "shared_library"
    system "make", "install" # Can't go in parallel of building the dylib
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <srtp/srtp.h>
      #include <stdlib.h>

      int main() {
        err_status_t err;
        err = srtp_init();
        if (err != err_status_ok) {
          fputs("failed srtp_init", stderr);
          return 1;
        }
        err = srtp_shutdown();
        if (err != err_status_ok) {
          fputs("failed srtp_shutdown", stderr);
          return 1;
        }
        return 0;
      }
    EOS
    args = ["-L#{lib}", "-I#{include}"]
    args += %w[test.c -o test -lsrtp]
    system ENV.cc, *args
    system "./test"
  end
end
