class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "http://www.zeromq.org/"
  url "https://github.com/zeromq/libzmq/releases/download/v4.2.0/zeromq-4.2.0.tar.gz"
  sha256 "53b83bf0ee978931f76fa9cb46ad4affea65787264a5f3d140bc743412d0c117"

  bottle do
    cellar :any
    sha256 "645c9105c89e648da736ce466dccbdf9b87c3b3a6cd6d57d7d7ca43876661232" => :sierra
    sha256 "b7dcf178923f7f1e47f69c2d01ca8b810e5b22c23f1af9dc9c88765e3fbe3d26" => :el_capitan
    sha256 "78c24719c7c8dbba157ca225b41d515190281eb27549caaa60a359ec9f33e3f1" => :yosemite
  end

  head do
    url "https://github.com/zeromq/libzmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
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
    ENV.universal_binary if build.universal?
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    args << "--with-pgm" if build.with? "libpgm"
    args << "--with-libsodium" if build.with? "libsodium"
    args << "--with-norm" if build.with? "norm"
    args << "--enable-drafts" if build.with?("drafts")

    ENV["LIBUNWIND_LIBS"] = "-framework System"
    ENV["LIBUNWIND_CFLAGS"] = "-I#{MacOS.sdk_path}/usr/include"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
