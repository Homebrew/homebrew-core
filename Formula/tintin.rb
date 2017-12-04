class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tintin/TinTin%2B%2B%20Source%20Code/2.01.3/tintin-2.01.3.tar.gz"
  sha256 "c55215ff4a73d4c651a8ecfdc323f981b62262338e0180bf5bdc95bbc1aefe2d"

  bottle do
    cellar :any
    sha256 "c145ddfed37a2fa59169a0206c8183c3d249925029471125b7f3d423d732aef0" => :high_sierra
    sha256 "54f0d71d82cef428d1745ccb9668e3c7c7059bce089ec3057bad8410fca36fc0" => :sierra
    sha256 "3deb1aa079eb9217b8b8c5739a09a0614eac26d9010c1316bf79e4ccc9afdad9" => :el_capitan
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
