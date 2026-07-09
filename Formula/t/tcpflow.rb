class Tcpflow < Formula
  desc "TCP/IP packet demultiplexer"
  homepage "https://github.com/simsong/tcpflow"
  url "https://corp.digitalcorpora.org/downloads/tcpflow/tcpflow-1.6.1.tar.gz"
  sha256 "436f93b1141be0abe593710947307d8f91129a5353c3a8c3c29e2ba0355e171e"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url "https://digitalcorpora.s3.us-west-2.amazonaws.com/?list-type=2&delimiter=%2F&prefix=downloads%2Ftcpflow%2F"
    regex(/tcpflow[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :xml do |xml, regex|
      xml.get_elements("//Contents/Key").filter_map do |item|
        item.text&.[](regex, 1)
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca1a18ffad5f2de19a52597725a0b8d2486dd77506d46afd7478c839750fd448"
    sha256 cellar: :any,                 arm64_sequoia: "8487cadd6630cded0a87ad961533fbd103970672b9cbb7408f8e6ab6fb464e7d"
    sha256 cellar: :any,                 arm64_sonoma:  "956ad859fc371561dc378e92509e92d2ef262c96a3b83971c2a53edfdc51bda2"
    sha256 cellar: :any,                 sonoma:        "bdf6869cace46de5693b2b18286aa4367811f3dfc6ca4037945c0c7e95533bb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d054124af47e0f4312fc3aedb46fd7e37337ee2255efc714587700999eb9620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff05bce1f7eba15bf1490094edeefd6ebce7bfb8e0285bdea1068820d72b49aa"
  end

  head do
    url "https://github.com/simsong/tcpflow.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost" => :build
  depends_on "openssl@4"

  uses_from_macos "bzip2"
  uses_from_macos "libpcap"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "bash", "./bootstrap.sh" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--mandir=#{man}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/tcpflow -v -r #{test_fixtures("test.pcap")} 2>&1")
    assert_match "Total flows processed: 2", output
    assert_match "Total packets processed: 11", output
    assert_match "<title>Test</title>", (testpath/"192.168.001.118.00080-192.168.001.115.51613").read
  end
end
