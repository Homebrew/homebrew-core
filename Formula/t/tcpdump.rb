class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/tcpdump-4.99.6.tar.gz"
  sha256 "5839921a0f67d7d8fa3dacd9cd41e44c89ccb867e8a6db216d62628c7fd14b09"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/tcpdump.git", branch: "master"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?tcpdump[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "f801b7b1f7dcecc71f8cecee3147a1469abc87ccbade07f89628c99b2a4a402f"
    sha256 cellar: :any,                 arm64_sequoia: "884b3e4ef5f4aa2853a36a960c8977aa7fde7abc7ece17c01d79264eb83ccb96"
    sha256 cellar: :any,                 arm64_sonoma:  "0b5d241847887ac54dd98b874ef61846e4e606e6a4181d61e91a8e96dd069dbc"
    sha256 cellar: :any,                 sonoma:        "f1d1f31399e5dbebbffcd35b70fa0e4240860828047e4ade009a85bd4e79394b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e64d475e30d608775b89020fadd69bba4c6b4fcba6f5beb01093a03218595734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f4c8f9ff9f7c7a60c082d95239fff8ae4df1c795d359bd5a03fc948323b9aca"
  end

  depends_on "libpcap"
  depends_on "openssl@4"

  def install
    system "./configure", "--disable-smb",
                          "--disable-universal",
                          "--with-crypto=#{Formula["openssl@4"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/tcpdump --help 2>&1")
    assert_match "tcpdump version #{version}", output
    assert_match "libpcap version #{Formula["libpcap"].version}", output
    assert_match "OpenSSL #{Formula["openssl@4"].version}", output

    match = if OS.mac?
      "tcpdump: en0: (cannot open BPF device) /dev/bpf0: Operation not permitted"
    else
      "tcpdump: eth0: You don't have permission to perform this capture on that device"
    end
    assert_match match, shell_output("#{bin}/tcpdump ipv6 2>&1", 1)
  end
end
