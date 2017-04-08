class Zyre < Formula
  desc "Local Area Clustering for Peer-to-Peer Applications"
  homepage "https://github.com/zeromq/zyre"
  url "https://github.com/zeromq/zyre/releases/download/v2.0.0/zyre-2.0.0.tar.gz"
  sha256 "8735bdf11ad9bcdccd4c4fd05cebfbbaea8511e21376bc7ad22f3cbbc038e263"

  head do
    url "https://github.com/zeromq/zyre.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-drafts", "Build and install draft classes and methods"

  depends_on "pkg-config" => :build
  depends_on "zeromq"
  depends_on "czmq"

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
    ]

    args << "--enable-drafts" if build.with? "drafts"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check-verbose"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
