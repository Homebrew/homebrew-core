class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tintin/TinTin%2B%2B%20Source%20Code/2.01.4/tintin-2.01.4.tar.gz"
  sha256 "dd22afbff45a93ec399065bae385489131af7e1b6ae8abb28f80d6a03b82ebbc"
  revision 2

  bottle do
    cellar :any
    sha256 "fbdf58d5dbba8cf3acf14c2691b7bc2408ef46cc2d1d720ee2baf0386da95f12" => :mojave
    sha256 "552223fd7efc3d68a99a1d49135a6537091f0d893e67f08eaf876e2385a0460d" => :high_sierra
    sha256 "58dbcc694fb3b80f10951d06f24fb4fd0e94eac1a3dc84017cd82e38610ff6a7" => :sierra
    sha256 "bd1fe99b7c2a458acd81a5a567ba57c664c99f9f5f73adb8845bae7d7363a151" => :el_capitan
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
