class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "http://www.zeromq.org/"
  url "https://github.com/zeromq/libzmq/releases/download/v4.3.1/zeromq-4.3.1.tar.gz"
  sha256 "bcbabe1e2c7d0eec4ed612e10b94b112dd5f06fcefa994a0c79a45d835cd21eb"

  bottle do
    cellar :any
    sha256 "3008730c651b01d2918e441ec88a1b9ed6e8dd5edca0c1d641ba45b28f32f5bb" => :mojave
    sha256 "69bbf4600e8ed82abb5883b105865f0464f734cd98e1cbcd352fc6cc3b7f3647" => :high_sierra
    sha256 "517e24924c9b3468b1d25a2817ea9fced48f9f26820ed28d2d6d553b3c00546c" => :sierra
  end

  head do
    url "https://github.com/zeromq/libzmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    if MacOS.version == :high_sierra
      ENV.delete("HOMEBREW_SDKROOT")
      ENV.delete("SDKROOT")
    end

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV["LIBUNWIND_LIBS"] = "-framework System"
    sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
    ENV["LIBUNWIND_CFLAGS"] = "-I#{sdk}/usr/include"

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
  end
end
