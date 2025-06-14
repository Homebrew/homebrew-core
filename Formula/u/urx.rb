class Urx < Formula
  desc "Extracts URLs from OSINT Archives for Security Insights"
  homepage "https://github.com/hahwul/urx"
  url "https://github.com/hahwul/urx/archive/refs/tags/0.6.1.tar.gz"
  sha256 "5e501198e6d910b39d0800266c32a22a17845e6b6324dbc16c5725525b8aec9a"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "949b36c006a4c88b7561392129ae672695b18605211d622b2cebe72f74630d35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e36f20d458d20ad6113bf1fe16fb01a33fdba4c791c6317e6a23ceaa574f468e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27eea88716e221fb2c1f93d2da038c16e97f4032080177b6ef0af6e4c616a212"
    sha256 cellar: :any_skip_relocation, sonoma:        "35fa3a01318a11855f673c291ac310f22abe82197997c6255fcffc8ece2525cd"
    sha256 cellar: :any_skip_relocation, ventura:       "365946aec8f9e136bea0b9a2460dc3959d83f9beaefa7389082c7d62d587f26b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "308c80edc3649d2aff17a156e17c5c829ccfd21d5c7a277f22fb17eb34e50511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2082d00257f7be453a2c14b3557dea56305c86e10e4daac629adff8798138a08"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "urx #{version}", shell_output("#{bin}/urx --version")
    assert_match "https://brew.sh/", shell_output("#{bin}/urx brew.sh --providers=cc --include-sitemap")
  end
end
