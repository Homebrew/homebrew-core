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
    sha256 cellar: :any,                 arm64_ventura:  "5363b4922b06c82726ae45c07c3631ccd47349f80267829a26627c5eb9ef28f7"
    sha256 cellar: :any,                 arm64_monterey: "8662fda1e6830511da0efab140fc8aa228148849cb248feab6191cf9b1de9355"
    sha256 cellar: :any,                 arm64_big_sur:  "39ada3d8d3e3bc34a390f8f648cd670b6871054a84bb712b6779b74d6f7f0dfe"
    sha256 cellar: :any,                 ventura:        "317e4d198368817d78f348bba73956c75051a77d3d53d3cafd449d6721f55c13"
    sha256 cellar: :any,                 monterey:       "885f34983135867ad1a10872b0b149e5c7baeb5de8804e69cf8a17bd056e373a"
    sha256 cellar: :any,                 big_sur:        "b520603806bc5d57569458485d2dfc55e87a61ba9d179fd3a2e954fb1c858d2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48a3e91e4eb8ccd2e7cdf0e4bc6b816d6be1b07edd0d0488ef5d406a7620227e"
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
