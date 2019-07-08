class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "http://www.zeromq.org/"
  url "https://github.com/zeromq/libzmq/releases/download/v4.3.2/zeromq-4.3.2.tar.gz"
  sha256 "ebd7b5c830d6428956b67a0454a7f8cbed1de74b3b01e5c33c5378e22740f763"

  bottle do
    cellar :any
    sha256 "f5837a7056c827b6fbe3b7758f87d78969ff01e5f91ece40050d58a2762ccca5" => :mojave
    sha256 "c520b34c98300a0b591559376b841050bc4f9d011392d8cebeb02f670de47fc0" => :high_sierra
    sha256 "7fbd2a2be3dcf6e83760627d0e1327dacebb9b39359d729438dd2468fe3b89e0" => :sierra
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
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
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
