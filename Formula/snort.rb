class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://www.snort.org/downloads/snort/snort-2.9.17.tar.gz"
  mirror "https://fossies.org/linux/misc/snort-2.9.17.tar.gz"
  sha256 "c3b234c3922a09b0368b847ddb8d1fa371b741f032f42aa9ab53d67b428dc648"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.snort.org/downloads"
    regex(/href=.*?snort[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "76b900e58098301dbe75180ffe678785cfc824388cdaf793226662a284ea6b0a" => :big_sur
    sha256 "c2c2c0cb2b5e84c5d893aa6a34e14ac10622a3c5bdc87c9c86420741e54a0267" => :catalina
    sha256 "f6fad9ce8ce49e23902d98ee6414ff0659beb0aee755ee143f5e6ff2817640be" => :mojave
    sha256 "028b03acd6446eee8fd8ba19ab54302f0b8a27d8315036bf6d80ca68fe191797" => :high_sierra
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
