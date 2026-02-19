class Tcpflow < Formula
  desc "TCP/IP packet demultiplexer"
  homepage "https://github.com/simsong/tcpflow"
  url "https://corp.digitalcorpora.org/downloads/tcpflow/tcpflow-1.6.1.tar.gz"
  sha256 "436f93b1141be0abe593710947307d8f91129a5353c3a8c3c29e2ba0355e171e"
  license "GPL-3.0-only"

  livecheck do
    url "https://digitalcorpora.s3.us-west-2.amazonaws.com/?list-type=2&delimiter=%2F&prefix=downloads%2Ftcpflow%2F"
    regex(/tcpflow[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :xml do |xml, regex|
      xml.get_elements("//Contents/Key").filter_map do |item|
        item.text&.[](regex, 1)
      end
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "dad7f4b569f0c8e74af53589c23537d577f58717c07662496902d2feb152638c"
    sha256 cellar: :any,                 arm64_sequoia: "00cefb494be45f397ef8ccd5dde9714f40b68afbffde7bfc00cb6ee150c8d5a5"
    sha256 cellar: :any,                 arm64_sonoma:  "84a6e56139366b507d9aab6c69ba2a6b7baef90062d2d195b5b61edabae7b6d9"
    sha256 cellar: :any,                 sonoma:        "0921dda7fcdf893d64b1bd807d3e6a8cbc716105c49f12a2ae27019c173d77e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f03cf13378d36ad9c60f50f3938054efd612de7be28bfc59a1a78c3ec11fd1df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b23f8c43c21e3857d31fdee5007f650bc79fc06d2205028bd0a1c613f5b5aba"
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
