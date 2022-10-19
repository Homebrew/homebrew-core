class Tcpflow < Formula
  desc "TCP/IP packet demultiplexer"
  homepage "https://github.com/simsong/tcpflow"
  url "https://downloads.digitalcorpora.org/downloads/tcpflow/tcpflow-1.6.1.tar.gz"
  sha256 "436f93b1141be0abe593710947307d8f91129a5353c3a8c3c29e2ba0355e171e"
  license "GPL-3.0-only"

  livecheck do
    url "https://downloads.digitalcorpora.org/downloads/tcpflow/"
    regex(/href=.*?tcpflow[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "805fe826bc05a38537a86946363e91a05e73b6bc96574f6fe88f91bf9a0b4d61"
    sha256 cellar: :any,                 arm64_big_sur:  "e1be2cb499df5ec033fb82cad85f743d0d024cec296aacfb3a2199bd12dc76de"
    sha256 cellar: :any,                 monterey:       "bd088bbedec62b5dcf6fb8d87a1a17d671e5f37226cb049dbba6a88f6b81424f"
    sha256 cellar: :any,                 big_sur:        "0b4121ad0f6a47b419677f4593ae1baa54b01c256cc469bac969064d5ab4e895"
    sha256 cellar: :any,                 catalina:       "0732205cc35bac2263dbb287294ff888ea4c383285489d31aac1ee8b1833200e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdc1b810dd8acb8ceea6bfe5c02dc03586f95c7572a0cb4acdebaccbc661b825"
  end

  head do
    url "https://github.com/simsong/tcpflow.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    system "bash", "./bootstrap.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/tcpflow -v -r #{test_fixtures("test.pcap")} 2>&1")
    assert_match "Total flows processed: 2", output
    assert_match "Total packets processed: 11", output
    assert_match "<title>Test</title>", (testpath/"192.168.001.118.00080-192.168.001.115.51613").read
  end
end
