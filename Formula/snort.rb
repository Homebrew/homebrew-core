class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://www.snort.org/downloads/snort/snort-2.9.16.tar.gz"
  mirror "https://fossies.org/linux/misc/snort-2.9.16.tar.gz"
  sha256 "9688d8edf1da09dec6574000fb3c0e62f99c56428587616e17c60103c0bcbad7"

  bottle do
    cellar :any
    rebuild 2
    sha256 "21333e3b46c2a9e9b64661a891a0d16558c888d9b260b1a713a7583d98e8999c" => :catalina
    sha256 "a900ea0646b89f1152f16dd0e86df4a5f8bd8de73269653bc4b6629110467bc0" => :mojave
    sha256 "a69f95c8452769835680ea5410db5c853749539758ebdb7aa38ed5ec1dde2a02" => :high_sierra
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
