class Xvid < Formula
  desc "High-performance, high-quality MPEG-4 video library"
  homepage "https://www.xvid.com/"
  url "http://downloads.xvid.org/downloads/xvidcore-1.3.5.tar.bz2"
  mirror "https://fossies.org/linux/misc/xvidcore-1.3.5.tar.bz2"
  sha256 "7c20f279f9d8e89042e85465d2bcb1b3130ceb1ecec33d5448c4589d78f010b4"

  bottle do
    cellar :any
    sha256 "d1715cb379f0b4be0b1bfed90b535fc4b9a0bf3dba87d00c258acaa15b312bc8" => :high_sierra
    sha256 "19b0870c1dcf33478526ac500461ee4bf41ad5cf8c3bae70035c12a967a7ecc6" => :sierra
    sha256 "9348879c2506816f6975bf62d3d9b1457b36b9c0093f8b08adffcb27005b5714" => :el_capitan
    sha256 "6c4882ee38401986bc42a7121d7c83674e4605f73f70e25d7cf49f8064ad39c5" => :yosemite
    sha256 "b3d6623ad887d3e9c663580f87460b18c89d40d14d81cc281c3aa5752bcbc26a" => :mavericks
    sha256 "08dbe9151754cbf5920c01f003c9c2a419455c3f01dd2679eb8bc9b25c5190a5" => :mountain_lion
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
