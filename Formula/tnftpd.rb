class Tnftpd < Formula
  desc "NetBSD's FTP server"
  homepage "https://cdn.netbsd.org/pub/NetBSD/misc/tnftp/"
  url "https://cdn.netbsd.org/pub/NetBSD/misc/tnftp/tnftpd-20200704.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/NetBSD/misc/tnftp/tnftpd-20200704.tar.gz"
  sha256 "92de915e1b4b7e4bd403daac5d89ce67fa73e49e8dda18e230fa86ee98e26ab7"

  livecheck do
    url :homepage
    regex(/href=.*?tnftpd[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f3744dddab0c9c5e6384b45925b7e97399227c9516c6befb32d6cfde89360a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da16904f59892ebef30355ea2dbaf1a0d5d6fe890d30c65b7d7f82992e4bc0de"
    sha256 cellar: :any_skip_relocation, monterey:       "cbecb6b4eb8a376217311ccafa6588b20839cd256ca6c997af2632cb41d04a05"
    sha256 cellar: :any_skip_relocation, big_sur:        "05728c1edd46c07fe6e19d54094d53dc78614cae7b04320794a9e4ba43dad099"
    sha256 cellar: :any_skip_relocation, catalina:       "cbc7f23e857584e25c7d2d043a3971841febe99f12830d82cf28fe47a2e9e254"
    sha256 cellar: :any_skip_relocation, mojave:         "3e8848729081c09a247e0326ede175db12111360905f69cc339dea3ba0213e62"
    sha256 cellar: :any_skip_relocation, high_sierra:    "18a15c1572f7f5b33b7678d9a322de20efcd0c1b1c5c98d8cb00e13a80bfa518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00a3f41077529f1428dcc9c99c4500c9d043032d174baa9ee1b735c91eb06dc3"
  end

  uses_from_macos "bison" => :build

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
    # Errno::EIO: Input/output error @ io_fillbuf - fd:5 /dev/pts/0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

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
