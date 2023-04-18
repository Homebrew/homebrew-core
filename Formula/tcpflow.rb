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
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "1f2a7ca46614781861f8c1f9a9d6af8b13320bf9ff03f830fa199ad250a094a3"
    sha256 cellar: :any,                 arm64_monterey: "a41756ac3931a3f64fba3000f2b86a02f844b69bdd41907ced290b9855f97aec"
    sha256 cellar: :any,                 arm64_big_sur:  "6e3f95b6a3d009e8f85c0da483e8759b37190710a4b74f1980b751bec54cd42b"
    sha256 cellar: :any,                 ventura:        "df7deb202cad6e5c8a51ed01ba5fcf16fddc80cccfda4eccc196bce7b6f9b0fd"
    sha256 cellar: :any,                 monterey:       "73e14653361b7c3276f5f5acd7e79c09982cc0f0d5f9c3f0102c1845bc5e5e95"
    sha256 cellar: :any,                 big_sur:        "b4bd69530d81550d1a428dff981fc71f5a45fd4cc406e9f10dee030e1b350b90"
    sha256 cellar: :any,                 catalina:       "96d3ce376bae12013a22db5a49e71bc45a8478a07ba7ef1bfb1dc1daa33e3bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0fb8e4d90327529dca426de617f298ec135fac0fca31e547551774832541aac"
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
