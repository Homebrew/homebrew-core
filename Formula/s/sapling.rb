class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.2.20230523-092610+f12b7eee.tar.gz"
  version "0.2.20230523-092610-f12b7eee"
  sha256 "57a04327052f900d95d0dd3800d8b13a411b08222307bb141109afca1d1d0eaf"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/facebook/sapling.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+[+-]\h+)$/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "9719427c4a27ed33aec85a6076a1b76480d2b65d52188e9bfb861baf724a55f4"
    sha256 cellar: :any,                 arm64_monterey: "bbb5e51e950d4dbd549cc4a3fb91028e2895bb7e5edeb8b036dfc0fa99e5dba5"
    sha256 cellar: :any,                 arm64_big_sur:  "22cfc7f1045aa2172b550e311f98b82809117e6d8b422441984c557362dac5ff"
    sha256 cellar: :any,                 ventura:        "492fe295bee2ac71fb20385895699daf83467be6a6d0bfaeaf8504bb2d158da0"
    sha256 cellar: :any,                 monterey:       "2fd38d0007761d0fa39d388a4accf18d29d55a8fe83f7a7f4bb11df3558d436d"
    sha256 cellar: :any,                 big_sur:        "63ed71121cbf672e38c4f6f16babb11f2198238393103d629a4383a98824c6a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3967a9b8b632d99ff9aee2df754425071103432131d9e47ee2871bbfac8f2bad"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "gh"
  depends_on "node"
  depends_on "openssl@3"
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

    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
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
