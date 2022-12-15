class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.1.20221213-150011-h9b0acf12.tar.gz"
  sha256 "1513f34ced2583cfdf202d6b8fb77beeda0d7298bd4d3f55a32d3e54796d1710"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "49bf9ec4f58d8349d4b6115258cfc569128384d516ad8e98dd916aebdc66984b"
    sha256 cellar: :any,                 arm64_monterey: "a98cca203bb709ed5f6d8c401879474dfbdaa008dd99b3aeb0328379b6da8b3b"
    sha256 cellar: :any,                 arm64_big_sur:  "c90af6e3e29acff0c159683ae3ec72e177e0200c181501a6a51a5e10bfd4aae7"
    sha256 cellar: :any,                 ventura:        "ebf0b109ec15347914db5cab0567bd6dc76cc1122f5109e23ecdd49128754ea6"
    sha256 cellar: :any,                 monterey:       "bffb541620c7561dbbf6cf568e56abec5d7babc0baadfcb3e3785021e9de2f45"
    sha256 cellar: :any,                 big_sur:        "915e9dacb59b84e15f49826affe53d9dd1400db98c3fc361e00701388ce65e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "611e7a822fa7b96ca591264b8c61184dcf4d8a5bfedbce8fe30460c6feda6f2e"
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
