class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tintin/TinTin%2B%2B%20Source%20Code/2.01.3/tintin-2.01.3.tar.gz"
  sha256 "c55215ff4a73d4c651a8ecfdc323f981b62262338e0180bf5bdc95bbc1aefe2d"

  bottle do
    cellar :any
    sha256 "415aa4fca1fcde634e92792546efaa0b200ed2fdbd1ff9a577a6ca12e7d3170c" => :high_sierra
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

  test do
    require "pty"
    (testpath/"input").write("#end {bye}\n")
    PTY.spawn(bin/"tt++", "-G", "input") do |r, _w, _pid|
      assert_match "Goodbye", r.read
    end
  end
end
