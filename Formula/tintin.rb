class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.00/tintin-2.02.00.tar.gz"
  sha256 "b1bc35f3137db378ba7f26c9f169ed8bcca4617ca4ec3356f14d0b083f5c150b"

  bottle do
    cellar :any
    sha256 "3da12a97145f035ed9ae5bf0f038800ff4a4f7aba014546e0e54960f64d414d8" => :catalina
    sha256 "ec78955fa2d9637332d29399c9b790e78567854b97847af5f6bc1fbb3a0ecaee" => :mojave
    sha256 "d907ef0afbbd3bc01792d8806968861e13b712b2228c5e505ba1996c075478e1" => :high_sierra
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
    shell_output("#{bin}/tt++ -e \"#nop; #info system; #end;\"")
  end
end
