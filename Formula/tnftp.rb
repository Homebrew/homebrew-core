class Tnftp < Formula
  desc "NetBSD's FTP client (built from macOS Sierra sources)"
  homepage "https://opensource.apple.com/"
  url "https://ftp.netbsd.org/pub/NetBSD/misc/tnftp/tnftp-20151004.tar.gz"
  sha256 "c94a8a49d3f4aec1965feea831d4d5bf6f90c65fd8381ee0863d11a5029a43a0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d64ad33eea88bd1b7f061c0eec784d259183d60376d0e5e4dbf3d07aef49ff74" => :catalina
    sha256 "286b8f6bfb0217e88c81305e28eb32aaa78c3d0528518372191c8364c080f351" => :mojave
    sha256 "d10b32070661a883375a361016f73c3be47f9702be5fa902ca491d3f12ed8022" => :high_sierra
    sha256 "8aca7a23ac918f7a69b13df67452420fb711e320cc57743cefd15134516da1ab" => :sierra
    sha256 "fdaf7c1ab1fcb48226a9846452b352e4da302ac6aca61a74a67f97b8bb21c942" => :el_capitan
  end

  conflicts_with "inetutils", :because => "both install `ftp' binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"

    bin.install "src/tnftp" => "ftp"
    man1.install "src/ftp.1"
    prefix.install_metafiles
  end

  test do
    require "pty"
    require "expect"

    PTY.spawn "#{bin}/ftp ftp://anonymous:none@speedtest.tele2.net" do |input, output, _pid|
      str = input.expect(/Connected to speedtest.tele2.net./)
      output.puts "exit"
      assert_match "Connected to speedtest.tele2.net.", str[0]
    end
  end
end
