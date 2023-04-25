class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.2.20230330-193452-h69692651.tar.gz"
  version "0.2.20230330-193452-h69692651"
  sha256 "d02130197dcc4be07e3697a55e298a1178c71d2255019287ea25f451f9f42541"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7e2204fdf4beddf1cc2eb9fb70c01a5ca995c5e8a78510e6868dc6a67b84392b"
    sha256 cellar: :any,                 arm64_monterey: "6a0802017e3629f2936454c1889adf4231191d4b6d34f134bb8f503e6c3814c1"
    sha256 cellar: :any,                 arm64_big_sur:  "17ba88bfd7dfb0a2886c14bfb61ef5fdef15a6fb0f717083222c7d460ed1f8ac"
    sha256 cellar: :any,                 ventura:        "5b4b19caba1027393e1ca51542275381c7d96d4cca3150f759384982feca7ac5"
    sha256 cellar: :any,                 monterey:       "b8905e95b9f827f16dcd669698241c8650de7dd7fdae6c8475a960bdf18d7b72"
    sha256 cellar: :any,                 big_sur:        "8c7378e9a7027c9473bb7c469fd4fab3f6b7ead402a901c39ee7fbef0d04939f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df64f25f00dc7f3f08ef6fc729703acaac8fe1750d26a22a0229e58a8e6049fc"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "gh"
  depends_on "node"
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  # `setuptools` 66.0.0+ only supports PEP 440 conforming version strings.
  # Modify the version string to make `setuptools` happy.
  def modified_version
    # If installing through `brew install sapling --HEAD`, version will be HEAD-<hash>, which
    # still doesn't make `setuptools` happy. However, since installing through this method
    # will get a git repo, we can use the ci/tag-name.sh script for determining the version no.
    build_version = if version.to_s.start_with?("HEAD")
      Utils.safe_popen_read("ci/tag-name.sh").chomp + ".dev"
    else
      version
    end
    segments = build_version.to_s.split(/[-+]/)
    "#{segments.take(2).join("-")}+#{segments.last}"
  end

  def install
    python3 = "python3.11"

    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["SAPLING_VERSION"] = modified_version

    # Don't allow the build to break our shim configuration.
    inreplace "eden/scm/distutils_rust/__init__.py", '"HOMEBREW_CCCFG"', '"NONEXISTENT"'
    system "make", "-C", "eden/scm", "install-oss", "PREFIX=#{prefix}", "PYTHON=#{python3}", "PYTHON3=#{python3}"
  end

  test do
    assert_equal("Sapling #{modified_version}", shell_output("#{bin}/sl --version").chomp)
    system "#{bin}/sl", "config", "--user", "ui.username", "Sapling <sapling@sapling-scm.com>"
    system "#{bin}/sl", "init", "--git", "foobarbaz"
    cd "foobarbaz" do
      touch "a"
      system "#{bin}/sl", "add"
      system "#{bin}/sl", "commit", "-m", "first"
      assert_equal("first", shell_output("#{bin}/sl log -l 1 -T {desc}").chomp)
    end
  end
end
