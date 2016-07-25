class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "http://www.zeromq.org/"
  url "https://github.com/zeromq/zeromq4-1/releases/download/v4.1.5/zeromq-4.1.5.tar.gz"
  sha256 "04aac57f081ffa3a2ee5ed04887be9e205df3a7ddade0027460b8042432bdbcf"

  bottle do
    cellar :any
    sha256 "8677f4e36376d84752b00a2c9801c1fe8519ee9db7b6df051c52d203f1e9575e" => :el_capitan
    sha256 "d987614f7d62306b6a2c9f51133f5e393678d25f5c8705821b40aebe956347b2" => :yosemite
    sha256 "306cde5d1e3fbd3defc36d3e2c88464dac3a82f0d7f0cc57c9dfffeac3e07600" => :mavericks
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

  deprecated_option "with-pgm" => "with-libpgm"

  depends_on "pkg-config" => :build
  depends_on "libpgm" => :optional
  depends_on "libsodium" => :optional
  depends_on "norm" => :optional

  def install
    ENV.universal_binary if build.universal?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    if build.with? "libpgm"
      # Use HB libpgm-5.2 because their internal 5.1 is b0rked.
      ENV["pgm_CFLAGS"] = `pkg-config --cflags openpgm-5.2`.chomp
      ENV["pgm_LIBS"] = `pkg-config --libs openpgm-5.2`.chomp
      args << "--with-pgm"
    end

    if build.with? "libsodium"
      args << "--with-libsodium"
    else
      args << "--without-libsodium"
    end

    args << "--with-norm" if build.with? "norm"

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
