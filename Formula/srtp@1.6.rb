class SrtpAT16 < Formula
  desc "Implementation of the Secure Real-time Transport Protocol (SRTP)"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v1.6.0.tar.gz"
  sha256 "1a3e7904354d55e45b3c5c024ec0eab1b8fa76fdbf4dd2ea2625dad2b3c6edde"

  bottle do
    cellar :any
    sha256 "18278298c00fe3fb462bcc07940c22330491010c576f1b000b813e9034f8cf5b" => :high_sierra
    sha256 "2efbca3a66bc62275a59f59d928a47704c6c13094de29ff36a2ebaa674c12104" => :sierra
    sha256 "f13b678175596b07b20d6b04571111548c84572455e01d4ae1bd1a102deb016e" => :el_capitan
    sha256 "2509b155840b3c95e97fb24d0bad341e1cce9c4b899c5f9b6fcecd36e6c1e8a0" => :yosemite
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
    (testpath/"test.c").write <<~EOS
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
