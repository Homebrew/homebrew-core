class Tnftp < Formula
  desc "NetBSD's FTP client"
  homepage "https://ftp.netbsd.org/pub/NetBSD/misc/tnftp/"
  url "https://ftp.netbsd.org/pub/NetBSD/misc/tnftp/tnftp-20200705.tar.gz"
  sha256 "ba4a92b693d04179664524eef0801c8eed4447941c9855f377f98f119f221c03"

  bottle do
    cellar :any_skip_relocation
    sha256 "92c012e712577f8241e239849d4b73dd5dba36a74b6bd66db6b834488a8d82cf" => :catalina
    sha256 "54e3a99702280bcc89879a9f520441113686869981ec534fa74db2df3fa7b774" => :mojave
    sha256 "ba323276cf1be330ad3fccab6cd4339e11bb67428ead33128b809b7fdfd7bf80" => :high_sierra
  end

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

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
