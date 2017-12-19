class Tnftpd < Formula
  desc "NetBSD's FTP server (built from macOS Sierra sources)"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/lukemftpd/lukemftpd-51.tar.gz"
  version "20100324"
  sha256 "969b8a35fabcc82759da2433973b9606b7b62f73527e76ac8f18d0a19f473c2a"

  keg_only :provided_pre_high_sierra

  depends_on :xcode => :build

  def install
    system "tar", "zxvf", "tnftpd-20100324.tar.gz"

    cd "tnftpd-20100324" do
      system "./configure"
      system "make"

      sbin.install "src/tnftpd" => "ftpd"
      man8.install "src/tnftpd.man" => "ftpd.8"
      man5.install "src/ftpusers.man" => "ftpusers.5"
      man5.install "src/ftpd.conf.man" => "ftpd.conf.5"
      etc.install "examples/ftpd.conf"
      etc.install "examples/ftpusers"
      prefix.install_metafiles
    end
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
