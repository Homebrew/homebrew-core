class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "http://www.zeromq.org/"
  url "https://github.com/zeromq/libzmq/releases/download/v4.2.3/zeromq-4.2.3.tar.gz"
  sha256 "8f1e2b2aade4dbfde98d82366d61baef2f62e812530160d2e6d0a5bb24e40bc0"

  bottle do
    cellar :any
    sha256 "24c5d175563a388a81df502e0e56b0bc16e2d2becdff05bb74adefa091a82264" => :high_sierra
    sha256 "e10289e3a44f78b2234347b04b9369f45455afa8b0fd61d538bc92a6de69b517" => :sierra
    sha256 "72ca74ca177ff8ffd765d2e010b5027e3640b1e68964b1e5c7f7f3acc0a6acdd" => :el_capitan
    sha256 "e98d0623b86749fe766a518d256493bd5cb78a73002a10dfb748a8c65763b45a" => :yosemite
  end

  head do
    url "https://github.com/zeromq/libzmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-libpgm", "Build with PGM extension"
  option "with-norm", "Build with NORM extension"
  option "with-drafts", "Build and install draft classes and methods"

  deprecated_option "with-pgm" => "with-libpgm"

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "libpgm" => :optional
  depends_on "libsodium" => :optional
  depends_on "norm" => :optional

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    args << "--with-pgm" if build.with? "libpgm"
    args << "--with-libsodium" if build.with? "libsodium"
    args << "--with-norm" if build.with? "norm"
    args << "--enable-drafts" if build.with?("drafts")

    ENV["LIBUNWIND_LIBS"] = "-framework System"
    sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
    ENV["LIBUNWIND_CFLAGS"] = "-I#{sdk}/usr/include"

    system "./autogen.sh" if build.head?
    system "./configure", *args
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
