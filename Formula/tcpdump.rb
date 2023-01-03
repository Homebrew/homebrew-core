class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/tcpdump-4.99.2.tar.gz"
  sha256 "f4304357d34b79d46f4e17e654f1f91f9ce4e3d5608a1badbd53295a26fb44d5"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/tcpdump.git", branch: "master"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?tcpdump[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "a23bc85b24fa8c354c34d421ba3a5a3a66813da733a3f92531951d50ee687247"
    sha256 cellar: :any,                 arm64_monterey: "c2d1c25d3bc51ab32b32ffa538b967ad5cd6c915de4cc027c561c4cbde945904"
    sha256 cellar: :any,                 arm64_big_sur:  "80ef73cbc460fdacb8615d7848579cf098c442fffdbc0b159a48e19e186be49d"
    sha256 cellar: :any,                 ventura:        "55d49386b8ec20e1653794f6086453280c51d7b0eff70b8a8daafef4c4852208"
    sha256 cellar: :any,                 monterey:       "50435f4a6d6ffeced288f07dfb03d2fcd2b28e7a9d86a17c3ab6956da977e014"
    sha256 cellar: :any,                 big_sur:        "202e53843212c66f95abf38b23bdd9ec5bef6061246d140736fcc28d7c25cce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d32f09a5e2f527168bbd33235719aa0a605ce0c9e298335ef63c33097ac90a57"
  end

  depends_on "libpcap"
  depends_on "openssl@3"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-smb",
                          "--disable-universal"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/tcpdump --help 2>&1")
    assert_match "tcpdump version #{version}", output
    assert_match "libpcap version #{Formula["libpcap"].version}", output
    assert_match "OpenSSL #{Formula["openssl@3"].version}", output

    match = if OS.mac?
      "tcpdump: (cannot open BPF device) /dev/bpf0: Operation not permitted"
    else
      <<~EOS
        tcpdump: eth0: You don't have permission to perform this capture on that device
        (socket: Operation not permitted)
      EOS
    end
    assert_match match, shell_output("#{bin}/tcpdump ipv6 2>&1", 1)
  end
end
