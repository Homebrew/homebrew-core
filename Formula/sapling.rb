class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.2.20230523-092610+f12b7eee.tar.gz"
  version "0.2.20230523-092610+f12b7eee"
  sha256 "57a04327052f900d95d0dd3800d8b13a411b08222307bb141109afca1d1d0eaf"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+[+-]\h+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5263595411b35494a7609d0d9fac0056ad64e889b944a1bee2d4b0bdd1607dfe"
    sha256 cellar: :any,                 arm64_monterey: "d75b9b4220c5ad4b3cccd4fd483c8a8db44c91183c94fcf2505f4c5c40cc9d7f"
    sha256 cellar: :any,                 arm64_big_sur:  "ba08f0f87d29db6dabfad158c070ded79a5f284030670bcbba3bca969621a226"
    sha256 cellar: :any,                 ventura:        "1449138a1e9a7af6363e2be04c0cf62c39b4d8454b546468f866487b2c66b9ed"
    sha256 cellar: :any,                 monterey:       "73c792f77b09b961ab5c955ebaddd0a4441e263af0263ad199781814f8307b78"
    sha256 cellar: :any,                 big_sur:        "9ee679317da2645941f34cecafd6d906931c557737dcce80fbab949ea70b9158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a294936462fb98ac095eedf9fd80dbc1c2680489085234cdf3682a106bef949f"
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
