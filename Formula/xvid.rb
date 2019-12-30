class Xvid < Formula
  desc "High-performance, high-quality MPEG-4 video library"
  homepage "https://labs.xvid.com/"
  url "https://downloads.xvid.com/downloads/xvidcore-1.3.7.tar.bz2"
  sha256 "aeeaae952d4db395249839a3bd03841d6844843f5a4f84c271ff88f7aa1acff7"

  bottle do
    cellar :any
    sha256 "7512de9c603f43159e8336358b52285ee74aa545f5dd7822cacdfa9158507b3a" => :catalina
    sha256 "aaa30d8e5033d88082da91d780699df848d095dafff39ee5c5cfa1f6a46c86ff" => :mojave
    sha256 "000de46bb386497c9d11a005825606e813034f8b819adaa09de12f15761de742" => :high_sierra
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
