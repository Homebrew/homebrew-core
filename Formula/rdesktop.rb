class Rdesktop < Formula
  desc "UNIX client for connecting to Windows Remote Desktop Services"
  homepage "https://www.rdesktop.org/"
  url "https://github.com/rdesktop/rdesktop/releases/download/v1.9.0/rdesktop-1.9.0.tar.gz"
  sha256 "473c2f312391379960efe41caad37852c59312bc8f100f9b5f26609ab5704288"

  bottle do
    sha256 "7c9514c2ed77ff7d2289b1f464ce187b3882cff9c7a0f3fbeb3473d085f7525c" => :catalina
    sha256 "38d60f4a835c4090ba1528f19cc7b47122ff22f1f85b1be69ae00bedb18da03b" => :mojave
    sha256 "4f20968750adad4b1d743ff3ee96262a0cb834b8a6ff9c41486479f71542b2e7" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libao"
  depends_on "libtasn1"
  depends_on "nettle"
  depends_on :x11

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-credssp
      --enable-smartcard
      --with-sound=libao
      --x-includes=#{MacOS::X11.include}
      --x-libraries=#{MacOS::X11.lib}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rdesktop -help 2>&1", 64)
  end
end
