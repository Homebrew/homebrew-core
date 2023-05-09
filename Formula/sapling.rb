class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.2.20230426-145232+7ea1f245.tar.gz"
  version "0.2.20230426-145232+7ea1f245"
  sha256 "5295cfbc7428f4cd88c722108fa75737b73e01a1cdbf79df236c0513b5c374cd"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+[+-]\h+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "23f9df5b51fcbff877a9763ebfc48f279ba9b681eb33139027c8eb871b474ade"
    sha256 cellar: :any,                 arm64_monterey: "6737b2d5219471f4c1528f3409fccaf93ec2c7a98ea76a128a2110c8acd88067"
    sha256 cellar: :any,                 arm64_big_sur:  "7dc454c4bd45caafab1b2a2216496941b5a2a195d1e9043ffc2c668cafe90d6d"
    sha256 cellar: :any,                 ventura:        "755c4086562cd478bf7f81e0e8d73d6536f359d7ca43353ef9c4595edd648305"
    sha256 cellar: :any,                 monterey:       "37b789ce002119d865b08cc73e504f749ccda80fbfbb4478768a973a9675d863"
    sha256 cellar: :any,                 big_sur:        "daa873c477eb67b67f6d29e0558d21bda3b88e3878668c3624ff3571b310886a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "427769aec56eac325a01f3610b4d89d83c624b8a60296abd44de2f0b026dd573"
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
