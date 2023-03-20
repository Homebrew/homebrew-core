class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.2.20230228-144002-h9440b05e.tar.gz"
  sha256 "70483afad6d0b437cb755447120a34b1996ec09a7e835b40ac8cccdfe44e4b90"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "b9aee4101baae22fe8b0e32a8eb9f086f63967851a9410960e36d3541c98845e"
    sha256 cellar: :any,                 arm64_monterey: "bcaa04164fc08e79065d1899e8ade085047090b40c63174fb81fa02ac8437646"
    sha256 cellar: :any,                 arm64_big_sur:  "5a0d6120c941935d1d0159b76b967968ca3421ec7f61fedb8d3bf0a6804589c5"
    sha256 cellar: :any,                 ventura:        "e90c415a3327d7e0823c5b4e31b3d84514bc19f25687d5e9a5c231d686a07c7e"
    sha256 cellar: :any,                 monterey:       "484be2fe2b901132f7c9cecb918dae45c7f43518a6ce2d2b57b816aeb536a7ac"
    sha256 cellar: :any,                 big_sur:        "bf39795492d13fa68e0a247982b913031d1ea873543c548c8aa790250b32ba60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "993b6d4628338f297b17eb1be68ffbea8bba85f54c76659e1db38d53b22974b1"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "gh"
  depends_on "node"
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  def install
    python3 = "python3.11"

    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["SAPLING_VERSION"] = version.to_s

    # Don't allow the build to break our shim configuration.
    inreplace "eden/scm/distutils_rust/__init__.py", '"HOMEBREW_CCCFG"', '"NONEXISTENT"'
    system "make", "-C", "eden/scm", "install-oss", "PREFIX=#{prefix}", "PYTHON=#{python3}", "PYTHON3=#{python3}"
  end

  test do
    assert_equal("Sapling #{version}", shell_output("#{bin}/sl --version").chomp)
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
