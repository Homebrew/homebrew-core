class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview"
  homepage "https://saldl.github.io/"
  url "https://github.com/saldl/saldl/archive/refs/tags/v41.tar.gz"
  sha256 "fc9980922f1556fd54a8c04fd671933fdc5b1e6847c1493a5fec89e164722d8e"
  license "AGPL-3.0-or-later"
  head "https://github.com/saldl/saldl.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "09d9a038aebe18f9b9b14b96303429a56caddda7425949c0cd5b6feb14de20c4"
    sha256 cellar: :any,                 arm64_sequoia:  "f6ca14c2df72bbec447ff0fbcbfe0b1b76070808210ec18c6822fc0579bb9053"
    sha256 cellar: :any,                 arm64_sonoma:   "b5473268647d0fb55defbd170569644c7545fedc20487531717db503ec43e2ab"
    sha256 cellar: :any,                 arm64_ventura:  "45ec76ad15d5c9c04d96bb467fa4d06605afa85675c7f4979f15e8c10d2231e9"
    sha256 cellar: :any,                 arm64_monterey: "1251f81d7ec7ef2faf2368564aa094363b9f2b16bc9a2f14637a62b73b1bfe93"
    sha256 cellar: :any,                 arm64_big_sur:  "a2fb9b1d61667447ddca0988edf3e059f008250ce7c132329b58a9d506619b91"
    sha256 cellar: :any,                 sonoma:         "d36fd42240ec138eff96597c4b4c7c26ab880a3bf9d71f094b7baba9c6662a8b"
    sha256 cellar: :any,                 ventura:        "4f0e1d940e661c286b891acf10e3ee073f43fc513431e238169a3d8363e384f3"
    sha256 cellar: :any,                 monterey:       "ac5cd4b2cf2c98914450f59547ee2e2ef995be33e0a23e81d0fe90c73d6e8353"
    sha256 cellar: :any,                 big_sur:        "a65269f2669815cf1590d9aeacff4639593edaf4f34be5964c793d01ad104eac"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bd1865579a7047c885722dcc0ab7a6352e4c038665ec309dc5fcd4fbb7228076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34ed09e4b4f2663075c8d514390cad8aade4b66b8cf2a40e4c46ee1bd23b199e"
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "curl" # curl >= 7.55 is required
  depends_on "libevent"

  uses_from_macos "python" => :build
  uses_from_macos "libxslt"

  # Update waf for python 3.11
  # Use resource instead of patch since applying corrupts waf
  # https://github.com/saldl/saldl/pull/15
  resource "waf" do
    url "https://raw.githubusercontent.com/saldl/saldl/360c29d6c8cee5f7e608af42237928be429c3407/waf"
    sha256 "93909bca823a675f9f40af7c65b24887c3a3c0efdf411ff1978ba827194bdeb0"
  end

  def install
    ENV.refurbish_args

    # a2x/asciidoc needs this to build the man page successfully
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    args = ["--prefix=#{prefix}"]

    # head uses git describe to acquire a version
    args << "--saldl-version=v#{version}" if build.stable?

    buildpath.install resource("waf")
    system "python3", "./waf", "configure", *args
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"
  end

  test do
    system bin/"saldl", "https://brew.sh/index.html"
    assert_path_exists testpath/"index.html"
  end
end
