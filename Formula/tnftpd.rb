class Tnftpd < Formula
  desc "NetBSD's FTP server (built from macOS Sierra sources)"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/lukemftpd/lukemftpd-51.tar.gz"
  version "20100324"
  sha256 "969b8a35fabcc82759da2433973b9606b7b62f73527e76ac8f18d0a19f473c2a"

  bottle do
    sha256 "b1682283462d7838ce7d4a180cfee8be9ea4db601d3b112f0d50b1e6ad90fd56" => :catalina
    sha256 "ce27ec83c1e3000355b624f25f8f0f6efbc14bda6436374c74c0ddeb2d67902b" => :mojave
    sha256 "ee9f7bc91071b5a4c625621593b78cf34cc01ee06b828c942afc6aa30cbee5ff" => :high_sierra
    sha256 "64d040373d1378a529947ad70460044013716d0e9fb0cbd2b5c81475caead3c7" => :sierra
    sha256 "4ef4b7c1a35307c4a3e6b70dad1ba193aceda75920da79b0a2bd135446863d5e" => :el_capitan
  end

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
