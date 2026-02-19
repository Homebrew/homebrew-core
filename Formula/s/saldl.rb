class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview"
  homepage "https://saldl.github.io/"
  url "https://github.com/saldl/saldl/archive/refs/tags/v41.tar.gz"
  sha256 "fc9980922f1556fd54a8c04fd671933fdc5b1e6847c1493a5fec89e164722d8e"
  license "AGPL-3.0-or-later"
  head "https://github.com/saldl/saldl.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "a941046f8ba35fc1e8eeb99f31488c55dfd0774d9d9b08143069995c3650ccbc"
    sha256 cellar: :any,                 arm64_sequoia: "b3957d4e8208f02cbbc5b63d24773bf412a1c6eaa25d40972670cf97fa7e996d"
    sha256 cellar: :any,                 arm64_sonoma:  "b1b8d88d136a6ac6f4612d53e6c96f3056d50a1701e6ab66d0a757d8242de828"
    sha256 cellar: :any,                 sonoma:        "6bc5294d547489d4eda5ddaa1f51153c2b3b36be366a5f4609c6a76f1f5d5428"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68a6ee008808e8ba34de2e6367ba7a70f675abd592f2bd59e9ae04224185e15f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fac01178e92d8772a63590e63904d14a95375b3aab7bf108c1f71fb3abe671b"
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"

  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build
  uses_from_macos "python" => :build
  uses_from_macos "curl"

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
