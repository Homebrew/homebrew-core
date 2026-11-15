class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/tcpdump-4.99.7.tar.gz"
  sha256 "8be364e28d3b745ef1459b385cd2f4bc0e1ebad7a5d2ebdf70071d6c9b5b9a54"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/tcpdump.git", branch: "master"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?tcpdump[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "341de462ccfc70404357d038d390069652d9b7797471d83ff96cd21302f4730f"
    sha256 cellar: :any, arm64_tahoe:       "784a23c965e8f634559e485dbd2f007cab67c26fa19a08cb0a5df382db4fb147"
    sha256 cellar: :any, arm64_sequoia:     "c12571f0e8bc8e57f9840ccba5613650f40b6a7ee857fa48e1113a6f6916e285"
    sha256 cellar: :any, arm64_linux:       "b6a2a75286adbe94f5c9e799dd74ecd8bbd0ff97a2b19cd641de9e7c1babc0a8"
    sha256 cellar: :any, x86_64_linux:      "da1037446a6f860d6c690636689fc92392eab6dbbad9382425fe7dc221f1e361"
  end

  depends_on "libpcap"
  depends_on "openssl@4"

  deny_network_access!

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def install
    system "./configure", "--disable-smb",
                          "--disable-universal",
                          "--with-crypto=#{formula_opt_prefix(openssl)}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/tcpdump --help 2>&1")
    assert_match "tcpdump version #{version}", output
    assert_match "libpcap version #{Formula["libpcap"].version}", output
    assert_match "OpenSSL #{Formula[openssl].version}", output

    match = if OS.mac?
      "tcpdump: en0: (cannot open BPF device) /dev/bpf0: Operation not permitted"
    else
      "tcpdump: eth0: You don't have permission to perform this capture on that device"
    end
    assert_match match, shell_output("#{bin}/tcpdump ipv6 2>&1", 1)
  end
end
