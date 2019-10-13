class Rdesktop < Formula
  desc "UNIX client for connecting to Windows Remote Desktop Services"
  homepage "https://www.rdesktop.org/"
  url "https://github.com/rdesktop/rdesktop/releases/download/v1.9.0/rdesktop-1.9.0.tar.gz"
  sha256 "473c2f312391379960efe41caad37852c59312bc8f100f9b5f26609ab5704288"

  bottle do
    sha256 "748c0fe4a854917a3403b084c9ce0843515f7ac9e522619d6f880f3a55c01908" => :catalina
    sha256 "c319fc2fceca931b83d5b05f6e2d9c1ae4687a277b1c71e4e5cb73e424759ef8" => :mojave
    sha256 "92a663dd356df68f0b86ec58e1f3f07d242aa6c66fda7c90dc41330b793f2c4d" => :high_sierra
    sha256 "c3514986d81f0b8c9e4e37e2dc6648ce4978d814dff3c5e187a9ead35fdadf0d" => :sierra
  end

  depends_on "openssl@1.1"
  depends_on :x11

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-credssp
      --enable-smartcard
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
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
