class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/tcpdump-4.99.5.tar.gz"
  sha256 "8c75856e00addeeadf70dad67c9ff3dd368536b2b8563abf6854d7c764cd3adb"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/tcpdump.git", branch: "master"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?tcpdump[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "bdf16573a1d3b7b374650072536dbf02491b83a60b606f34e023af5bb3551efc"
    sha256 cellar: :any,                 arm64_sequoia:  "1148ef2fa8284dd4f3501fbb831e355d1802ff312588e964000e8bf6119d5f1a"
    sha256 cellar: :any,                 arm64_sonoma:   "3f5043c5db6891bd831a8c669d502d7b648e94c5d7879bfc50bbd19c3206d966"
    sha256 cellar: :any,                 arm64_ventura:  "fe74349a8c4053d8174b151fa0a5f08ad21bde866b32c98d17352cdaf2979407"
    sha256 cellar: :any,                 arm64_monterey: "0931f78d5219508116403e1b5bc32c350f41391ecc09e91e79700ee6f6afacf3"
    sha256 cellar: :any,                 sonoma:         "8b597346315197c4496008670bc19b707b9101f2fc3f8c3cb5ce27660b15f1af"
    sha256 cellar: :any,                 ventura:        "c89ac387870a36878ec784a2596001604fb8e45bf08b843cc67bca65b6b8b2e8"
    sha256 cellar: :any,                 monterey:       "747664cf9fe675ea183ab0296ac49e94b787cf7872d312796b44f389f4f9fe5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8962c15fc888b856a9996e75496920d235e191aba7026856cf18ed26315b8e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93fbba2a9bdd304e8aaa4c78e6f74b8e41de3312bd444833320f4dbe09b08dc9"
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
