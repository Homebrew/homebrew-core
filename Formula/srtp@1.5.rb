class SrtpAT15 < Formula
  desc "Implementation of the Secure Real-time Transport Protocol (SRTP)"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v1.5.2.tar.gz"
  sha256 "86e1efe353397c0751f6bdd709794143bd1b76494412860f16ff2b6d9c304eda"

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
