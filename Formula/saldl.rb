class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview"
  homepage "https://saldl.github.io/"
  url "https://github.com/saldl/saldl/archive/v41.tar.gz"
  sha256 "fc9980922f1556fd54a8c04fd671933fdc5b1e6847c1493a5fec89e164722d8e"
  license "AGPL-3.0"
  head "https://github.com/saldl/saldl.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "7d946fb405f3e50a3bd407a5deb8d1dc1c71094cd5092d9a314385e0165d446b"
    sha256 cellar: :any, arm64_big_sur:  "2b965040a5e53c33801a86f8090a3339b8967903b1a11c3cc5b8bfca9e9de33c"
    sha256 cellar: :any, monterey:       "bf33da07c23b69e41cdc44c0bcef25625128da44e134ac0f3417bd60fe67801e"
    sha256 cellar: :any, big_sur:        "787ac1c4f96155b215ebc0eb06b6fbb404ac4dcca1cd88670c127ec1d504d709"
    sha256 cellar: :any, catalina:       "9ac9aaa7e2882bcdb821c33c5bf7013b2ba1221242c1ad7d3da4e85d8febb324"
    sha256 cellar: :any, mojave:         "3384921f2669ccb3e6021260c81b9494165ddf32f8f69dc0d4196910d4afe6be"
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "curl" # curl >= 7.55 is required
  depends_on "libevent"

  def install
    ENV.refurbish_args

    # a2x/asciidoc needs this to build the man page successfully
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = ["--prefix=#{prefix}"]

    # head uses git describe to acquire a version
    args << "--saldl-version=v#{version}" unless build.head?

    system "./waf", "configure", *args
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system "#{bin}/saldl", "https://brew.sh/index.html"
    assert_predicate testpath/"index.html", :exist?
  end
end
