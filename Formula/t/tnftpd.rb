class Tnftpd < Formula
  desc "NetBSD's FTP server"
  homepage "https://cdn.netbsd.org/pub/NetBSD/misc/tnftp/"
  url "https://cdn.netbsd.org/pub/NetBSD/misc/tnftp/tnftpd-20231001.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/NetBSD/misc/tnftp/tnftpd-20231001.tar.gz"
  sha256 "24a51bd2e5818ddb8c2479df9c8175a78dd8a5ef49ee3ab09f5f39c35069826e"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "ISC"]

  livecheck do
    url :homepage
    regex(/href=.*?tnftpd[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9d9d80e1b2f1df559934eb827edb881709d86a7197e56c47fb3fae56b01b4a0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b0896487aea674c344c0b0018f331767231546c8269d940de9910f2107a17b26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2553f19ea668a58de5f03311347e89a3522e458c9d9482ea3ae4a8825ae34eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "846e191bdee68e9a0123e864e7683917efce53a479ecfaa1448422bc512024af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "011a300c9b49318f006a133c9967d2a5968862e427204d578752b692105070e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "8985fce13cecf1bc9e202f30ea4a5c9cd19c417ff4eb7afe6cd8d08dfd02a819"
    sha256 cellar: :any_skip_relocation, ventura:        "80301322ab495d2380c7be37f703293f89b6a0956b27fe6f796ce493ca862da2"
    sha256 cellar: :any_skip_relocation, monterey:       "1c0f3a77356aa9ea4a691f0388cf4e9ad42002c7d67a09fa18b500d0172abe0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "59f715a746e1ae9772414c45c5739d3c10061c9a2fac68e0a2efdc0280d08a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef05fc95a88ae0c7ca0fba016115eb2d840d4a218935f39d137f61a5e63144ef"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "libxcrypt"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"

    sbin.install "src/tnftpd" => "ftpd"
    man8.install "src/tnftpd.man" => "ftpd.8"
    man5.install "src/ftpusers.man" => "ftpusers.5"
    man5.install "src/ftpd.conf.man" => "ftpd.conf.5"
    etc.install "examples/ftpd.conf"
    etc.install "examples/ftpusers"
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
