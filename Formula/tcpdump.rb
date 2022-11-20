class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/tcpdump-4.99.1.tar.gz"
  sha256 "79b36985fb2703146618d87c4acde3e068b91c553fb93f021a337f175fd10ebe"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/tcpdump.git", branch: "master"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?tcpdump[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "46e34484eae8d19ecb7a043fadaf97d57ff129ca13de047110279b9a5651964e"
    sha256 cellar: :any,                 arm64_monterey: "d71d0cc113fd1118d055762736255d98758c41c62b5fbafa85168cbf878dcf61"
    sha256 cellar: :any,                 arm64_big_sur:  "a59443b03462d0e8551309f149374a359ad004c296a10fbdfeccc63917a8145c"
    sha256 cellar: :any,                 ventura:        "2629960e8aea5d02dd71fd2bf1002d2357ddb26776901c5fb36bbae5dee0ab6c"
    sha256 cellar: :any,                 monterey:       "89c4882162fbe7d4ca38f84541ecf209a7fa4c000a9222180f42dc9058ba134d"
    sha256 cellar: :any,                 big_sur:        "a19c2e85b694e3d96d39a63641c86c5bac9dafc4b54066e5daa446ff25aa8cdc"
    sha256 cellar: :any,                 catalina:       "309850763dc7ffe8410fb5ef889bf9587f56312b3f210f0274cf3322084b8b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef086e7e00f74fbaa800b4ab34d3eda6fca98f54e22e951892d6a8c9abfe615b"
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
        tcpdump: eth0: You don't have permission to capture on that device
        (socket: Operation not permitted)
      EOS
    end
    assert_match match, shell_output("#{bin}/tcpdump ipv6 2>&1", 1)
  end
end
