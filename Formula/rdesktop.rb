class Rdesktop < Formula
  desc "UNIX client for connecting to Windows Remote Desktop Services"
  homepage "https://www.rdesktop.org/"
  url "https://github.com/rdesktop/rdesktop/releases/download/v1.9.0/rdesktop-1.9.0.tar.gz"
  sha256 "473c2f312391379960efe41caad37852c59312bc8f100f9b5f26609ab5704288"
  license "GPL-3.0"
  revision 1

  bottle do
    sha256 "4b504df078255fec4d85c94f9a815eb26e55cec1cd38ebf2755ead4d0bcda3be" => :catalina
    sha256 "12d99aa6dd32ee04b5c0030def99ec91ec9de695d11bd7e062429e760a5ece94" => :mojave
    sha256 "16afb599f321df0271f1b7b10eb93884b111feefc4cfb7b116ccf7b90dfede46" => :high_sierra
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
