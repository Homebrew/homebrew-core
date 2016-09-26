class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://www.snort.org/downloads/snort/snort-2.9.8.3.tar.gz"
  sha256 "856d02ccec49fa30c920a1e416c47c0d62dd224340a614959ba5c03239100e6a"

  bottle do
    cellar :any
    sha256 "d6e0d7b077ab1bd0d5a157290cf5b02959341263adb570a46a8d284547420a12" => :sierra
    sha256 "a9d181fa99b247f0393f80eb6c95144d69148479baf3b91133f48f6f347a558c" => :el_capitan
    sha256 "32c6242acec71ab2a9ae4723e7ca70779c91070441f5d2d2a073b6fac83e2385" => :yosemite
    sha256 "9118f3787b7fd32a4750ceae0bdc5923e911bed9515b7587fb527f9459e2c84b" => :mavericks
  end

  option "with-debug", "Compile Snort with debug options enabled"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on "luajit"
  depends_on "daq"
  depends_on "libdnet"
  depends_on "pcre"
  depends_on "openssl"

  def install
    openssl = Formula["openssl"]

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/snort
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-gre
      --enable-mpls
      --enable-targetbased
      --enable-sourcefire
      --with-openssl-includes=#{openssl.opt_include}
      --with-openssl-libraries=#{openssl.opt_lib}
      --enable-active-response
      --enable-normalizer
      --enable-reload
      --enable-react
      --enable-flexresp3
    ]

    if build.with? "debug"
      args << "--enable-debug"
      args << "--enable-debug-msgs"
    else
      args << "--disable-debug"
    end

    system "./configure", *args
    system "make", "install"

    rm Dir[buildpath/"etc/Makefile*"]
    (etc/"snort").install Dir[buildpath/"etc/*"]
  end

  def caveats; <<-EOS.undent
    For snort to be functional, you need to update the permissions for /dev/bpf*
    so that they can be read by non-root users.  This can be done manually using:
        sudo chmod o+r /dev/bpf*
    or you could create a startup item to do this for you.
    EOS
  end

  test do
    system bin/"snort", "-V"
  end
end
