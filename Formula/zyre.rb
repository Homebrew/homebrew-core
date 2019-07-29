class Zyre < Formula
  desc "Local Area Clustering for Peer-to-Peer Applications"
  homepage "https://github.com/zeromq/zyre"
  url "https://github.com/zeromq/zyre/releases/download/v2.0.0/zyre-2.0.0.tar.gz"
  sha256 "8735bdf11ad9bcdccd4c4fd05cebfbbaea8511e21376bc7ad22f3cbbc038e263"

  bottle do
    cellar :any
    sha256 "0bcd7f6da37e2249b2a80b00703064ec2b1332bff9979a40bff84a19c38c1d3f" => :mojave
    sha256 "7f9c25da501db588f3268e4f1fe99ec58357b41cd601a61859ebbce2eb875dee" => :high_sierra
    sha256 "f8f694368da98cd4781d43b1e4e18db94584ce1f8508b41d492d81194a15db3c" => :sierra
    sha256 "1402b11567fa689064366bf9f8fe9527dba8dfe9246e35b02130a344aa879a9b" => :el_capitan
    sha256 "1170a594d0eff7a57df26150d92daa37382ca6469d320e84957afb184560f691" => :yosemite
  end

  head do
    url "https://github.com/zeromq/zyre.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "czmq"
  depends_on "zeromq"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check-verbose"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <zyre.h>

      int main()
      {
        uint64_t version = zyre_version ();
        assert(version >= 2);

        zyre_test(true);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lzyre", "-o", "test"
    system "./test"
  end
end
