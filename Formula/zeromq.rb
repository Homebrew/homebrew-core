class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "https://zeromq.org/"
  url "https://github.com/zeromq/libzmq/releases/download/v4.3.4/zeromq-4.3.4.tar.gz"
  sha256 "c593001a89f5a85dd2ddf564805deb860e02471171b3f204944857336295c3e5"
  license "LGPL-3.0-or-later" => { with: "LGPL-3.0-linking-exception" }

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "cba9a73d51f994fd2554821c627ebf32dd63983510506e40b0d8f607df099252" => :big_sur
    sha256 "2d79d98097eb803e649f836f6cb9365915f447b6837a5a1255483e386b60048a" => :arm64_big_sur
    sha256 "5dbb8f4b8ffca7829eedea2a30ca8c85f98f03e221d9274ae9856d3b155fb5e0" => :catalina
    sha256 "a1d0f42e686c108d06ad4f376f8e8c666fda1edd1947edc772669062f3ccb1ff" => :mojave
  end

  head do
    url "https://github.com/zeromq/libzmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "xmlto" => :build

  depends_on "libsodium"

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    if MacOS.version == :high_sierra
      ENV.delete("HOMEBREW_SDKROOT")
      ENV.delete("SDKROOT")
    end

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Disable libunwind support due to pkg-config problem
    # https://github.com/Homebrew/homebrew-core/pull/35940#issuecomment-454177261

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--with-libsodium"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <zmq.h>

      int main()
      {
        zmq_msg_t query;
        assert(0 == zmq_msg_init_size(&query, 1));
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lzmq", "-o", "test"
    system "./test"
    system "pkg-config", "libzmq", "--cflags"
    system "pkg-config", "libzmq", "--libs"
  end
end
