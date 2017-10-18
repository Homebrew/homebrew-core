class ZeromqAT41 < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "http://www.zeromq.org/"
  url "https://github.com/zeromq/zeromq4-1/releases/download/v4.1.6/zeromq-4.1.6.tar.gz"
  sha256 "02ebf60a43011e770799336365bcbce2eb85569e9b5f52aa0d8cc04672438a0a"

  bottle do
    cellar :any
    sha256 "f7466ab3f8304519401d15f28055fe3a1e1e1b015d197cb1576ff789c0072c85" => :high_sierra
    sha256 "e700b4b8c44cd8d10e2a537fdf1f5331ad793ca5cfaa17d4f56b624189ceddd9" => :sierra
    sha256 "34ecd9741d19b20fb597a6609abfef9d50e2d46620bc6b64a134838b7796f999" => :el_capitan
    sha256 "5cc32b092021d8f0977e732279046feb15e6701f63abe3ebe99f524dcee8533c" => :yosemite
  end

  keg_only :versioned_formula

  option "with-libpgm", "Build with PGM extension"
  option "with-norm", "Build with NORM extension"

  depends_on "pkg-config" => :build
  depends_on "libpgm" => :optional
  depends_on "libsodium" => :optional
  depends_on "norm" => :optional

  def install
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lzmq", "-o", "test"
    system "./test"
  end
end
