class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.1.20221201-095354-r360873f1.tar.gz"
  sha256 "667149b8f705d87a24a80e7704a60cd0aa7cbfd0c63ae5363bb3717159be40ac"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "gh"
  depends_on "node"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["PYTHON_SYS_EXECUTABLE"] = Formula["python@3.8"].opt_prefix/"bin/python3.8"
    ENV["PYTHON"] = Formula["python@3.8"].opt_prefix/"bin/python3.8"
    ENV["PYTHON3"] = Formula["python@3.8"].opt_prefix/"bin/python3.8"
    ENV["SAPLING_VERSION"] = version.to_s

    cd "eden/scm" do
      system "make", "PREFIX=#{prefix}", "install-oss"
    end
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
