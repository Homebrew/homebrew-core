class Xvid < Formula
  desc "High-performance, high-quality MPEG-4 video library"
  homepage "https://labs.xvid.com/"
  url "https://downloads.xvid.com/downloads/xvidcore-1.3.7.tar.bz2"
  sha256 "aeeaae952d4db395249839a3bd03841d6844843f5a4f84c271ff88f7aa1acff7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.xvid.com/downloads/"
    regex(/href=.*?xvidcore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "58aa3f757ca260fb922ee623240b710ef7e1cc75dea00c314d6d5ecd98289cbf"
    sha256 cellar: :any,                 arm64_monterey: "ccf0c5b732d140dce8c595ff6bad287ed5be49a2c6a05912a1dbfdedfcb232bf"
    sha256 cellar: :any,                 arm64_big_sur:  "8974d7b8f816f7d5e8d9ae967b94922e0ed212f22f6475b7fa4c80c7a95d6582"
    sha256 cellar: :any,                 ventura:        "4726e597ea39861c53660614ebba7270095f12e99d76085f4bf0956408e91e38"
    sha256 cellar: :any,                 monterey:       "57aae7b7565705fdd83b0c2996cf0d2e3569546e9691197d175431b89a9599b9"
    sha256 cellar: :any,                 big_sur:        "feabfa1a3df3b916654ba5eef30193b65cdba70a7a49cca6406ec0c214b50338"
    sha256 cellar: :any,                 catalina:       "ace5fea6272f3594b5c8fca6f1fe03c41c50a14af8599751571c5e44a49a5a53"
    sha256 cellar: :any,                 mojave:         "4e119534a1351c85799944eb35f6f5675192e67e077fb3452f73f210a57eabe3"
    sha256 cellar: :any,                 high_sierra:    "79ea46af3061561427ab0af36b09d61e057084c76f655ec21074fba375a36b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93bd40f313f5a6656ce1ca70cfeacf67deacd647beaf204ab3fd610a2d92c5a7"
  end

  def install
    cd "build/generic" do
      system "./configure", "--disable-assembly", "--prefix=#{prefix}"
      ENV.deparallelize # Work around error: install: mkdir =build: File exists
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
