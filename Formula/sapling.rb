class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.2.20221222-152408-ha6a66d09.tar.gz"
  sha256 "9fb65d42c3c96769f01cedbc45d99b9aec833009283da2fd8438e18e92178588"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2695525a3c5956b26f460d19e9e09d0ac06206a6d50dec8bdb6ef97967d4bc8f"
    sha256 cellar: :any,                 arm64_monterey: "204acf1174773ae64b216d0dbe4bb359e9abcf8b41267a8dd15922b9dbe12c31"
    sha256 cellar: :any,                 arm64_big_sur:  "648720c6abce147ab540e8987754886e8a5fd1cb31e250f14e5442ea2cd9fd62"
    sha256 cellar: :any,                 ventura:        "6e99e4722d96d1ed75235c856b232188fa50b8e9349556ff9bcb844dea4a624f"
    sha256 cellar: :any,                 monterey:       "506618c14eca2c834f009d2c781950f0a9ea466f44e4bd0adcc21833c591f75d"
    sha256 cellar: :any,                 big_sur:        "bc82657408afd6475db3a0f3d2fa514fdf27115c1e21d8b6afe4f000aedc1295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d69a0f54a857cae17d3999b71dba9dbb137a8e342708f96b48d0b04bbefe47fa"
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
