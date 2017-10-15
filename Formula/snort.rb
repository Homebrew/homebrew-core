class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://www.snort.org/downloads/snort/snort-2.9.11.tar.gz"
  sha256 "23a45e3ea1e155a3d871c691a10fe23f2bfcfe4d6abc0ebbcdc2ab1fccca14ee"

  bottle do
    cellar :any
    sha256 "36682a3be8757c07b42ef5a89daa6b5f731bc7a0ec5f278d48c90c750f0d5a10" => :high_sierra
    sha256 "5d6cc5c781d24f76623a3442d38afd9d9a40d274df2961476a9ff486062e8271" => :sierra
    sha256 "ff73aa865a80e9a4d592eb9b860d79e5c124079116127e848b88e2cdbc7fc183" => :el_capitan
    sha256 "050a278c7a6606d2120f44ab573542efad3da1091d2ba27fd3eaedd0b5e4ac3a" => :yosemite
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
