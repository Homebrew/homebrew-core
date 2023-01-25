class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.2.20230124-180750-hf8cd450a.tar.gz"
  sha256 "0bfa0145edb269e3b9efedd658dbd17fff20c57c2524d08d12be3b75a69a36ed"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "c036e222d143c7981396f4b340355fa3a48dd3128e7e24f4b4034f1aad2929f7"
    sha256 cellar: :any,                 arm64_monterey: "fbd9ab62885f8df04e26432af6dd467264dd8ef9e7a11902ab2c5c681ff9b55b"
    sha256 cellar: :any,                 arm64_big_sur:  "080f25c8b24191128f695c23003f98565155d29ff252d9eaf17a83bd4584697f"
    sha256 cellar: :any,                 ventura:        "0bc67c4c0cdb97800190b4e56e8e45bd81792668cd134e9127846b8455b8cd96"
    sha256 cellar: :any,                 monterey:       "54fe8b9c4f27818df26b14954577db97463c664e6f4d0638cb48c16df971532e"
    sha256 cellar: :any,                 big_sur:        "23909c8e55fb2ee7da01d05ac0d4338264244ebd0921484e79d49ac99f6f0aab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7705b0102e8c5b599b4f3c3f6bf0eb61f762a3a4adeb814d2e35950601eaa232"
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
