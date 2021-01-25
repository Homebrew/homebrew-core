class Zyre < Formula
  desc "Local Area Clustering for Peer-to-Peer Applications"
  homepage "https://github.com/zeromq/zyre"
  url "https://github.com/zeromq/zyre/releases/download/v2.0.0/zyre-2.0.0.tar.gz"
  sha256 "8735bdf11ad9bcdccd4c4fd05cebfbbaea8511e21376bc7ad22f3cbbc038e263"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b374dcd00327e30d0bb99288ca4dc1fd1304b28bbbc8e361cff80b50c7bdbe59" => :big_sur
    sha256 "6ed734120e6a952217364ab40a993db6f9ef07cd4df83cc82424667cb253a1af" => :arm64_big_sur
    sha256 "b394d2d699797fe05ea0f175af99782ac980aae7700354b2df18529aeffa86ec" => :catalina
    sha256 "81de23b6fc5592333202d9cb96e66322e1f25925789a69aac62345068e5ef5b7" => :mojave
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
