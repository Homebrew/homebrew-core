class Tnftp < Formula
  desc "NetBSD's FTP client"
  homepage "https://ftp.netbsd.org/pub/NetBSD/misc/tnftp/"
  url "https://ftp.netbsd.org/pub/NetBSD/misc/tnftp/tnftp-20200705.tar.gz"
  sha256 "ba4a92b693d04179664524eef0801c8eed4447941c9855f377f98f119f221c03"

  livecheck do
    url :homepage
    regex(/href=.*?tnftp[._-]v?(\d+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f66f2de23252bca8e6ce5073adff9e86a0c928548b5a5c3cd2ea12f3a702d389" => :big_sur
    sha256 "1411f5fe465b0952891ff141431a5d09140c7d53bb3cf689054a2580bd1031fc" => :catalina
    sha256 "ae4beaa65c5f258152fefeeaa196c9e2d70cf3bda2af4e387ddcf807476c7401" => :mojave
    sha256 "900f2ece9b7a6a9edd0d96dc6c061ef6380c0fc99177119e73db65e5d8c012e0" => :high_sierra
  end

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  conflicts_with "inetutils", because: "both install `ftp' binaries"

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
