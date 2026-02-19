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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a666fc57f87e8f3947aaf879dc686caa9a007e1a774978a8c4aeb6aaa824418a"
    sha256 cellar: :any,                 arm64_sequoia: "06303bf329b37adf4025e8db096ae455ee5387d4e1ed50f2a2322402a557f262"
    sha256 cellar: :any,                 arm64_sonoma:  "ded86f8b06bd536b27ab058b16017e2e624d4471c551b83ac73802990138c6f5"
    sha256 cellar: :any,                 sonoma:        "bd53114b2966e8390780c8551d68796f44d0cc4223aca8c84205df81de2c3209"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebbebd3ee52544f48fdec76b8efa5c62003ba1055f8247d0422eb097d7b6d704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2acf63d0a7c95b63db681253f76b43d355e826265c33ccc55d8cd2b70cf6c631"
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
      "tcpdump: en0: (cannot open BPF device) /dev/bpf0: Operation not permitted"
    else
      "tcpdump: eth0: You don't have permission to perform this capture on that device"
    end
    assert_match match, shell_output("#{bin}/tcpdump ipv6 2>&1", 1)
  end
end
