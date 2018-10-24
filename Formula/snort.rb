class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://www.snort.org/downloads/snort/snort-2.9.11.1.tar.gz"
  sha256 "9f6b3aeac5a109f55504bd370564ac431cb1773507929dc461626898f33f46cd"

  bottle do
    cellar :any
    sha256 "7eb1bf8de87e1f55412cbc27e4b7e25d37819506481a036058d666ca2c62052e" => :mojave
    sha256 "ac8a7b3007b307d8368da7e3879e3c6cd6c718746b9443d544f5e8adcb286be6" => :high_sierra
    sha256 "b152a9869efd30d40e0d3750a0fd12f825360bf7c1d7cb39156320d32381a649" => :sierra
    sha256 "00de9088a3e7471026430cf17a7cc7d3d9787496398662c2e2c6a7c766c212cd" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "daq"
  depends_on "libdnet"
  depends_on "luajit"
  depends_on "openssl"
  depends_on "pcre"

  def install
    openssl = Formula["openssl"]

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
