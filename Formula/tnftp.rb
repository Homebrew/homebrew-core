class Tnftp < Formula
  desc "NetBSD's FTP client"
  homepage "https://ftp.netbsd.org/pub/NetBSD/misc/tnftp/"
  url "https://ftp.netbsd.org/pub/NetBSD/misc/tnftp/tnftp-20151004.tar.gz"
  sha256 "c94a8a49d3f4aec1965feea831d4d5bf6f90c65fd8381ee0863d11a5029a43a0"

  bottle do
    cellar :any_skip_relocation
    sha256 "92c012e712577f8241e239849d4b73dd5dba36a74b6bd66db6b834488a8d82cf" => :catalina
    sha256 "54e3a99702280bcc89879a9f520441113686869981ec534fa74db2df3fa7b774" => :mojave
    sha256 "ba323276cf1be330ad3fccab6cd4339e11bb67428ead33128b809b7fdfd7bf80" => :high_sierra
  end

  conflicts_with "inetutils", :because => "both install `ftp' binaries"

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

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
