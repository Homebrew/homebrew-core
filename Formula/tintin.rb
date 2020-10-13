class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.04/tintin-2.02.04.tar.gz"
  sha256 "479216011134568b43dbe872a3c2c7dc2a2fb0874bf6655f2a6f468637103ef0"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/scandum/tintin/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "3b8fecfa663f78f0edec61abc0e532d478bda181b832ae08b3151853246cceba" => :catalina
    sha256 "7e05318c54110a557db0491bd69403492e6e8b4253ed4cfb15bd55f5e61b8ffe" => :mojave
    sha256 "b10c42eb1687e1d67f686ea69b6e8271ca4ada7a982dfc626f21e6f2d99fe409" => :high_sierra
  end

  depends_on "gnutls"
  depends_on "pcre"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "CFLAGS=#{ENV.cflags}",
                     "INCS=#{ENV.cppflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tt++ -V", 1)
  end
end
