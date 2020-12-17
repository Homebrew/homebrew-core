class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "https://zeromq.org/"
  url "https://github.com/zeromq/libzmq/releases/download/v4.3.3/zeromq-4.3.3.tar.gz"
  sha256 "9d9285db37ae942ed0780c016da87060497877af45094ff9e1a1ca736e3875a2"
  license "LGPL-3.0-or-later" => { with: "LGPL-3.0-linking-exception" }
  revision 1

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "3a0cde0350d5604c6d0a51120893cbb6a953e784c356afe5276ba431ae5936b6" => :big_sur
    sha256 "5310a4204987850db552bb2746c48171a0faf51692c9f52debf10f85ac4db569" => :catalina
    sha256 "b67097dee2a42630e01978befe5c173f2a976c16fe4190873997776a584e4559" => :mojave
    sha256 "fee7be7f0a0762755037f3cd2ab1207dc9af43b0b75bf517d5f6f522a315a3bd" => :high_sierra
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
