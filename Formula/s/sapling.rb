class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.2.20230523-092610+f12b7eee.tar.gz"
  version "0.2.20230523-092610+f12b7eee"
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
    sha256 cellar: :any,                 arm64_ventura:  "748a832b6fc9303b9488ffa419eede0a11f213601d628dafe6e4036ef49411d2"
    sha256 cellar: :any,                 arm64_monterey: "6e22574bc80d85053a8b9cd006c81dcad636030b1a553040d812070c6f717e89"
    sha256 cellar: :any,                 arm64_big_sur:  "de6bbe1417ece08160a301761cf9e5b89850a31e7ece5d7e37bf2ff29df0fb8a"
    sha256 cellar: :any,                 ventura:        "834be18db23a6d79822165626ea0940eb6cb69926b4f0a5a2d69b68cf1fcb453"
    sha256 cellar: :any,                 monterey:       "2b2eeb0531b0d8134845f15ebd193edff8a97f271e85419d4fe07a5c6a19d34a"
    sha256 cellar: :any,                 big_sur:        "21ec5396066114414ae3c587cbcf1a501d3aa16b34f4b24ef645678d9b9034bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e043c11958e614bfb4d74f65c4e1f3549e4942c7c52d5b2222af0b1ccdcc600"
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
