class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://www.snort.org/downloads/snort/snort-2.9.18.tar.gz"
  mirror "https://fossies.org/linux/misc/snort-2.9.18.tar.gz"
  sha256 "d0308642f69e0d36f70db9703e5766afce2f44ff05b7d2c9cc8e3ac8323b2c77"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.snort.org/downloads"
    regex(/href=.*?snort[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "b37d8c8359f6a93a00db53db85c4d9dc7d064e508b8d18e7aa9e52d1e564085a"
    sha256 cellar: :any, catalina: "63ce2a1835beb2c93172672f4c470a7517d040cc31f7075ddb2bee2ca7028355"
    sha256 cellar: :any, mojave:   "56916b49728b2c9d449b31137bea8daf76e5a300d9197f108f3354a42229d512"
  end

  depends_on "pkg-config" => :build
  depends_on "daq"
  depends_on "libdnet"
  depends_on "libpcap"
  depends_on "luajit"
  depends_on "nghttp2"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "xz"

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

    # Currently configuration files in etc have strange permissions which causes postinstall to fail
    # Reported to upstream: https://lists.snort.org/pipermail/snort-devel/2020-April/011466.html
    (buildpath/"etc").children.each { |f| chmod 0644, f }
    rm Dir[buildpath/"etc/Makefile*"]
    (etc/"snort").install (buildpath/"etc").children
  end

  def caveats
    <<~EOS
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
