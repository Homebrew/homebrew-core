class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.sourceforge.io/"
  url "https://downloads.sourceforge.net/tintin/tintin-2.01.90.tar.gz"
  sha256 "6b3eef2a993250d7094c5fcd4aa6ea3e2356228b006c70062f5757577c86936c"

  bottle do
    cellar :any
    sha256 "ec973156e15950829255f554229f0787465c3c2fe25fd8f69dd954be209f5bdc" => :mojave
    sha256 "6631fb2271ee2f791ead160d473de77dc249c6924f89e0d8dcb041e1ce338b7a" => :high_sierra
    sha256 "61cbde7c970e7f1eff79fe5397a349f086225c6b25f21c4d2d1119aa4c221c9f" => :sierra
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
    require "pty"
    (testpath/"input").write("#end {bye}\n")
    PTY.spawn(bin/"tt++", "-G", "input") do |r, _w, _pid|
      assert_match "Goodbye", r.read
    end
  end
end
