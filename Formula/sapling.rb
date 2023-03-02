class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.2.20230124-180750-hf8cd450a.tar.gz"
  sha256 "0bfa0145edb269e3b9efedd658dbd17fff20c57c2524d08d12be3b75a69a36ed"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5aae62d7eaf9b8ae4ecd457e17f4eee3756eeb73cd91afcbbf14f6b52637c5a0"
    sha256 cellar: :any,                 arm64_monterey: "267bf9cdca87d786d14b383a68a28eec93f173ce5704c6c197ec610665f85f7a"
    sha256 cellar: :any,                 arm64_big_sur:  "2d6f53c7cb45d76d1fe181c5dfb79ec559d837a5db1c5f7ae2d385a7291401d3"
    sha256 cellar: :any,                 ventura:        "572a16c9cc4ebdc267b7515eb016d422bd277c46e4ee4758d4b3640fa69e8222"
    sha256 cellar: :any,                 monterey:       "2596ef4cea6b5cc0177bbb70d1695b2e1729796d6f75c0146a2fdc5da77daf6e"
    sha256 cellar: :any,                 big_sur:        "5308a2311873a6cad5e9828fac701aff3a846b854a0b17875ba208630c9350e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "419baf25b6c60081bfa4dce3648aaa9455225d06c9462eb6a94cc71ba5d8090f"
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
