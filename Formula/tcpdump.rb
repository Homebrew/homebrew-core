class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/tcpdump-4.99.0.tar.gz"
  sha256 "8cf2f17a9528774a7b41060323be8b73f76024f7778f59c34efa65d49d80b842"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/tcpdump.git"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?tcpdump[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "b50a5490d79832388f80dc89e46e2ce6fc13a267499cf839382e7bf43c726747" => :big_sur
    sha256 "6abbd38848e7a3aeac239e6422b94e74bbc8cc6a288f178627d578e69bf7e89e" => :arm64_big_sur
    sha256 "d4a3781175e0ce1d1a1048a3e211b8775dcec91e362fb51b3384e7404be3b4b6" => :catalina
    sha256 "6cd2cafe6229e2ccb97ba0b636e19a89c9e2f0ec85778910ed55498a30c03eb3" => :mojave
    sha256 "22f03cae37a35d6369292efd2c661f781df8dc21184046e768e13c148dbb3f19" => :high_sierra
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
    system sbin/"tcpdump", "--help"
  end
end
