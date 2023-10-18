class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/tcpdump-4.99.4.tar.gz"
  sha256 "0232231bb2f29d6bf2426e70a08a7e0c63a0d59a9b44863b7f5e2357a6e49fea"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/tcpdump.git", branch: "master"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?tcpdump[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ea69752d486c8e690d770e13b7601823634dcee1edc3a29bf9b9f7564655af38"
    sha256 cellar: :any,                 arm64_ventura:  "da8ef856d26aebf828f5f34df8f0db416824debbcc1ff3b608b3651e772410b7"
    sha256 cellar: :any,                 arm64_monterey: "5741abd85abf4c21ee78ba80983c68351206d0129ce60c54bafd69146ce478b5"
    sha256 cellar: :any,                 arm64_big_sur:  "1722402b5ee8397fe1c8bf5fb90e0e15ac277d65761b9f80d2b613d12da6a1d3"
    sha256 cellar: :any,                 sonoma:         "e55b1c248e5b37594755066046aaecaac89b3a0fdf08d3c0b4d962dfd13e1f0b"
    sha256 cellar: :any,                 ventura:        "b0711aab51b74e2ed9a6d067e006245d55d37c89bea9bdda21df92655aca2f00"
    sha256 cellar: :any,                 monterey:       "b929cb0bf2ad6a9ff4d3c9fb62646d257dd095ff540bb44259b3bb5ab27b9704"
    sha256 cellar: :any,                 big_sur:        "acdf5f172d82af424e721a51f37d55d646318ebd685c498ffeb2d5c785bc8c9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cb384cb6f8c9edcec6288d08bea8bf834da35b9d1c138c357e8765af2c7f1f7"
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
