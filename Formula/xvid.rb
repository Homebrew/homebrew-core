class Xvid < Formula
  desc "High-performance, high-quality MPEG-4 video library"
  homepage "https://labs.xvid.com/"
  url "https://downloads.xvid.com/downloads/xvidcore-1.3.5.tar.bz2"
  mirror "https://fossies.org/linux/misc/xvidcore-1.3.5.tar.bz2"
  sha256 "7c20f279f9d8e89042e85465d2bcb1b3130ceb1ecec33d5448c4589d78f010b4"

  bottle do
    cellar :any
    sha256 "38a308902e050aa6a84136e313ff710d363f7a434050a59593bc54c84d209730" => :catalina
    sha256 "c1c30c17a4715958fa2fa27fb060b2835c02818b46342d6534131af8729ebd65" => :mojave
    sha256 "618a58566676d49621cafc2278f1d94e5eaa443a57b1621ea4b040f49972ff94" => :high_sierra
    sha256 "6e62d9ca4544df9545b7bffbadd3c80a609d49ce12a94886f3310578ea2aaf88" => :sierra
    sha256 "1161fb4826f77c79deb33c494c31d934b9f46eac60d61ec3e5ea5c56b018d614" => :el_capitan
  end

  def install
    cd "build/generic" do
      system "./configure", "--disable-assembly", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <xvid.h>
      #define NULL 0
      int main() {
        xvid_gbl_init_t xvid_gbl_init;
        xvid_global(NULL, XVID_GBL_INIT, &xvid_gbl_init, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lxvidcore", "-o", "test"
    system "./test"
  end
end
