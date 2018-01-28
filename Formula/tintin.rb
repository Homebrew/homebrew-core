class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tintin/TinTin%2B%2B%20Source%20Code/2.01.4/tintin-2.01.4.tar.gz"
  sha256 "dd22afbff45a93ec399065bae385489131af7e1b6ae8abb28f80d6a03b82ebbc"
  revision 1

  bottle do
    cellar :any
    sha256 "20b753a099b4e1b373644159d0a8ca6c3dd9936d7ed80893cbe54c103e420e9e" => :high_sierra
    sha256 "dfd430eba6604dc4f24cac804f9105ec653c02bb1a828a71d1085a148f25654b" => :sierra
    sha256 "85fa5212c0caa90e256120c1640b11c525a9279e56c35417c0a43af7f182041d" => :el_capitan
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
