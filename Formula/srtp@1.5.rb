class SrtpAT15 < Formula
  desc "Implementation of the Secure Real-time Transport Protocol (SRTP)"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v1.5.4.tar.gz"
  sha256 "56a7b521c25134f48faff26b0b1e3d4378a14986a2d3d7bc6fefb48987304ff0"

  bottle do
    cellar :any
    sha256 "574082dd0e1214e6aaf6d4a0e7515eac1d29faef7b8d9c817757d9ba76688b61" => :sierra
    sha256 "563c8b58a1333c177d79ca153c53463941201a5ac01738be23f50cb99ffe79f5" => :el_capitan
    sha256 "6a71d0cdc64d62df915ade2c3e107317e98ffeb28902f99eb3c890af0f88999f" => :yosemite
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
