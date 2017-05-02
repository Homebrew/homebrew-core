class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tintin/TinTin%2B%2B%20Source%20Code/2.01.2/tintin-2.01.2.tar.gz"
  sha256 "01e11e3cded48ff686b2ea16e767acf1f6b5ea326551ecff091552e89f4a038e"

  bottle do
    cellar :any
    sha256 "83b285b7b301a92fab1edcf9123bd5a14c1e25b79e899d638a8ff6d0d624a05c" => :sierra
    sha256 "e58eb5055b943111c93dd2ede24df92b9b0d2ada69b128d43d4a837cc045ba5b" => :el_capitan
    sha256 "0fe0c128b0c4d22a6015e56220f3906a2e61e3b17294a5cf68e03104fbd33c06" => :yosemite
  end

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
end
