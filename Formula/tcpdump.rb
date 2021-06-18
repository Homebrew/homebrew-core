class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/tcpdump-4.99.1.tar.gz"
  sha256 "79b36985fb2703146618d87c4acde3e068b91c553fb93f021a337f175fd10ebe"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/tcpdump.git"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?tcpdump[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "76240f2c1366e4ff70ec2a7a4faecdd8a39b57ba4641a88a01850e773a408964"
    sha256 cellar: :any, big_sur:       "f13d5873a6d26314c930711e8565ce1265ac127a8470952aadda54232bbc9e8f"
    sha256 cellar: :any, catalina:      "4238eca3a7436080167e6b83054e10e14774cc77368d0e84e6e6914d34bf7290"
    sha256 cellar: :any, mojave:        "c919c1dde35897ff9bb40f367e4f286808ca6eeaf31ae99c279dfb779e9f4785"
  end

  depends_on "libpcap"
  depends_on "openssl@1.1"

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
    assert_match "OpenSSL #{Formula["openssl@1.1"].version}", output

    assert_match "tcpdump: (cannot open BPF device) /dev/bpf0: Operation not permitted",
      shell_output("#{bin}/tcpdump ipv6 2>&1", 1)
  end
end
