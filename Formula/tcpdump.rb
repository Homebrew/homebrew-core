class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/tcpdump-4.99.3.tar.gz"
  sha256 "ad75a6ed3dc0d9732945b2e5483cb41dc8b4b528a169315e499c6861952e73b3"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/tcpdump.git", branch: "master"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?tcpdump[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b33c4addd0f1ec9af10f8691ddb2716fd7ca47c5bc5a4ce39358da55db0b1888"
    sha256 cellar: :any,                 arm64_monterey: "2416ed4b8a86f1700e25483225ecdb3e57d33b617d3d45b047cde802228d58fb"
    sha256 cellar: :any,                 arm64_big_sur:  "73d923e5fd399c31e1869e378a544acacc8a74fb0e9caa3fd8999356feef1820"
    sha256 cellar: :any,                 ventura:        "9ae6838569eb4a21f209986c92ffeabff6eb149fa45486825e4814ea814d867a"
    sha256 cellar: :any,                 monterey:       "528aa714548708e58e93888bd1cfff7fe3bfd275ce3c8e6f9c2cb79de15c430e"
    sha256 cellar: :any,                 big_sur:        "89aa688017890881645ea2ef0b1f60113cd0c646972d469caebc041a2db23611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a41d0464433c574eb957196fa32043bac09a156b89e89eb27c47dcf5e30902d"
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
