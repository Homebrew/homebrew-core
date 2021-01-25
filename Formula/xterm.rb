class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-363.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_363.orig.tar.gz"
  sha256 "d81a3639e26552b6765bdcf28be1ecdb8acabf907955708e830ad6397ea10b48"
  license :cannot_represent

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "45e3a423a20fe31fcf03dc765dae216ab0fda4e7398cef54c028d698c4aa3a68" => :big_sur
    sha256 "d5c6fa1a6c8ad5f943f19577ca5c7da12a45248548411f7918887151dcd78656" => :arm64_big_sur
    sha256 "4331f8c3953e7dc90e11b2e900a93d0271f9b71cccf9112012df1f3df0ed17e3" => :catalina
    sha256 "db27bd9910af953635e4e041e0b86c3a127cbb6131090a2059e0e191c3e138dd" => :mojave
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libice"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxinerama"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    %w[koi8rxterm resize uxterm xterm].each do |exe|
      assert_predicate bin/exe, :exist?
      assert_predicate bin/exe, :executable?
    end
  end
end
