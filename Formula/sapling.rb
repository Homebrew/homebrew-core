class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.2.20221222-152408-ha6a66d09.tar.gz"
  sha256 "9fb65d42c3c96769f01cedbc45d99b9aec833009283da2fd8438e18e92178588"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6bc71e05ec35152091844a9edd907790fe4e682f76f78232dbd5439c4f865267"
    sha256 cellar: :any,                 arm64_monterey: "20fb92aa067a58e6d0f98fe8c9579b3c53e3564cf4071c3689c3c58e0d3181ee"
    sha256 cellar: :any,                 arm64_big_sur:  "d2618c12558536c7cafa5ffd59fbf7f72344ae2596cc71def0a38d55eec1f7ba"
    sha256 cellar: :any,                 ventura:        "97922191c684a7e0ac8efa83f518a8ede12c8188f95d060c5b6ee8e92baa0c60"
    sha256 cellar: :any,                 monterey:       "c02d344d5789dc08a1dd3da2dbc9a93ca0124339551642ffdcca6a9ada180ae0"
    sha256 cellar: :any,                 big_sur:        "b016d2423d7027734fc2b1f70942f1307c9e00c58ddb1e996f7dd53abcea0575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba13cec240a7f1a81a209b00e7d6316ea5a52b25d1f8283a76a1f7854e862807"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "gh"
  depends_on "node"
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["PYTHON_SYS_EXECUTABLE"] = Formula["python@3.10"].opt_prefix/"bin/python3.10"
    ENV["PYTHON"] = Formula["python@3.10"].opt_prefix/"bin/python3.10"
    ENV["PYTHON3"] = Formula["python@3.10"].opt_prefix/"bin/python3.10"
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
