class Xvid < Formula
  desc "High-performance, high-quality MPEG-4 video library"
  homepage "https://labs.xvid.com/"
  url "https://downloads.xvid.com/downloads/xvidcore-1.3.7.tar.bz2"
  sha256 "aeeaae952d4db395249839a3bd03841d6844843f5a4f84c271ff88f7aa1acff7"
  license "GPL-2.0"

  livecheck do
    url "https://downloads.xvid.com/downloads/"
    regex(/href=.*?xvidcore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "feabfa1a3df3b916654ba5eef30193b65cdba70a7a49cca6406ec0c214b50338" => :big_sur
    sha256 "8974d7b8f816f7d5e8d9ae967b94922e0ed212f22f6475b7fa4c80c7a95d6582" => :arm64_big_sur
    sha256 "ace5fea6272f3594b5c8fca6f1fe03c41c50a14af8599751571c5e44a49a5a53" => :catalina
    sha256 "4e119534a1351c85799944eb35f6f5675192e67e077fb3452f73f210a57eabe3" => :mojave
    sha256 "79ea46af3061561427ab0af36b09d61e057084c76f655ec21074fba375a36b01" => :high_sierra
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
