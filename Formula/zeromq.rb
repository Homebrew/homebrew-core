class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "http://www.zeromq.org/"
  url "https://github.com/zeromq/libzmq/releases/download/v4.2.5/zeromq-4.2.5.tar.gz"
  sha256 "cc9090ba35713d59bb2f7d7965f877036c49c5558ea0c290b0dcc6f2a17e489f"

  bottle do
    cellar :any
    sha256 "bf4eeef1c1b76258f261294e096013e579966b7031754b52f9503981611d4c7e" => :mojave
    sha256 "de552cb61eea442ce7935cf3d5adcd5c194f3536e6de541e3d412b55493d3a70" => :high_sierra
    sha256 "b564e9f3b8e30e324701d7eb30e83a8ea703e3b5f4f7049a30f0574d510b92ea" => :sierra
    sha256 "c90d4d425e1b9e6f8a73c576880a0f0bcc027b33739c45ae2ee3e8e3ef9b62a3" => :el_capitan
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
