class ZeromqAT40 < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "http://www.zeromq.org/"
  url "https://github.com/zeromq/zeromq4-x/releases/download/v4.0.8/zeromq-4.0.8.tar.gz"
  sha256 "56b652e622ee30456d3c2ce86d8b6a979a00bfe4ea3828d483a5e90864dac1dc"

  bottle do
    cellar :any
    sha256 "206c152d5346b27e4894b799de98a5332c3a53ed38fd43b2a22471edd230bd4b" => :sierra
    sha256 "a20cef84d5f9e5e9a288e9226b7526c04af19db58cb3871aff5fef23fba237c7" => :el_capitan
    sha256 "2751cbf620c6045a06fdba82f94965bcc199f642ab6f6f7f016fe65c3d2e5c79" => :yosemite
  end

  keg_only :versioned_formula

  option "with-libpgm", "Build with PGM extension"

  depends_on "pkg-config" => :build
  depends_on "libpgm" => :optional
  depends_on "libsodium" => :optional

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    if build.with? "libpgm"
      # Use HB libpgm-5.2 because their internal 5.1 is b0rked.
      ENV["OpenPGM_CFLAGS"] = `pkg-config --cflags openpgm-5.2`.chomp
      ENV["OpenPGM_LIBS"] = `pkg-config --libs openpgm-5.2`.chomp
      args << "--with-system-pgm"
    end

    if build.with? "libsodium"
      args << "--with-libsodium"
    else
      args << "--without-libsodium"
    end

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
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lzmq", "-o", "test"
    system "./test"
  end
end
