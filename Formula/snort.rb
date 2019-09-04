class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://www.snort.org/downloads/snort/snort-2.9.12.tar.gz"
  mirror "https://distfiles.macports.org/snort/snort-2.9.12.tar.gz"
  sha256 "7b02e11987c6cb4f6d79d72799ca9ad2b4bd59cc1d96bb7d6c91549f990d99d0"
  revision 1

  bottle do
    cellar :any
    sha256 "2451928b0b98275ecedb347024ea33ed80bb7fca6e67f6f60bd2343159d960d5" => :mojave
    sha256 "e90378116097477c70bf92381c6fcd5ac122939a1c06c0afaadd797e38fd549f" => :high_sierra
    sha256 "7143a99771c1482070dc7802da36bc25cc4df7c59c55fd4ad9cb3646e1b60fe2" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "daq"
  depends_on "libdnet"
  depends_on "libpcap"
  depends_on "luajit"
  depends_on "nghttp2"
  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    openssl = Formula["openssl@1.1"]
    libpcap = Formula["libpcap"]

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/snort
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-active-response
      --enable-flexresp3
      --enable-gre
      --enable-mpls
      --enable-normalizer
      --enable-react
      --enable-reload
      --enable-sourcefire
      --enable-targetbased
      --with-openssl-includes=#{openssl.opt_include}
      --with-openssl-libraries=#{openssl.opt_lib}
      --with-libpcap-includes=#{libpcap.opt_include}
      --with-libpcap-libraries=#{libpcap.opt_lib}
    ]

    system "./configure", *args
    system "make", "install"

    rm Dir[buildpath/"etc/Makefile*"]
    (etc/"snort").install Dir[buildpath/"etc/*"]
  end

  def caveats; <<~EOS
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
