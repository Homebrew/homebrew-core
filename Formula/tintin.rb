class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.04/tintin-2.02.04.tar.gz"
  sha256 "479216011134568b43dbe872a3c2c7dc2a2fb0874bf6655f2a6f468637103ef0"
  license "GPL-3.0"

  livecheck do
    url "https://github.com/scandum/tintin/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "5655e2bfaf4fb9932f2b9317745f97b73162bd12d926a8fd9783002449d8ed3a" => :catalina
    sha256 "b10d78dd09e94adac5f9a4aaeddc756b7ee578e9a77ef9f81f8c4f1941f90c3c" => :mojave
    sha256 "9f4a88c8da68bde84fc56b34ef86b53e1691d33a59e340c54aa18b50c7c88f46" => :high_sierra
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
