class Tnftpd < Formula
  desc "NetBSD's FTP server"
  homepage "https://ftp.netbsd.org/pub/NetBSD/misc/tnftp/"
  url "https://ftp.netbsd.org/pub/NetBSD/misc/tnftp/tnftpd-20200704.tar.gz"
  sha256 "92de915e1b4b7e4bd403daac5d89ce67fa73e49e8dda18e230fa86ee98e26ab7"

  bottle do
    cellar :any_skip_relocation
    sha256 "978a0f4a68060b3565a38e3dac5cae51970c63380b9d711cc0627fc22fa92e5c" => :catalina
    sha256 "73c8ee8157c115bdb3460ed5d6e99026eb202ee92eb2b5e0fc8210f38b8cd0e1" => :mojave
    sha256 "b57aef0f28f51866e63ee22df0c3068377bebb4a36c17e7d0f167e3a97f7591f" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"

    sbin.install "src/tnftpd" => "ftpd"
    man8.install "src/tnftpd.man" => "ftpd.8"
    man5.install "src/ftpusers.man" => "ftpusers.5"
    man5.install "src/ftpd.conf.man" => "ftpd.conf.5"
    etc.install "examples/ftpd.conf"
    etc.install "examples/ftpusers"
    prefix.install_metafiles
  end

  def caveats
    <<~EOS
      You may need super-user privileges to run this program properly. See the man
      page for more details.
    EOS
  end

  test do
    # running a whole server, connecting, and so forth is a bit clunky and hard
    # to write properly so...
    require "pty"
    require "expect"

    PTY.spawn "#{sbin}/ftpd -x" do |input, _output, _pid|
      str = input.expect(/ftpd: illegal option -- x/)
      assert_match "ftpd: illegal option -- x", str[0]
    end
  end
end
