class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.11.0.tar.gz"
  sha256 "ffaf51f0742d4a782a0926b3456e527b813d0966d0fc367643a55e58b00d52e6"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c9480f47474829e54328853c89b0df59e4006262235bc1ecc1a1b167b949e36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d4223fbfa757d959e044f4c5423389290dd61ed8852ecb753849fd97365a80e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e54ba472494dae61fea3719d92fd5cdc31b84f15736da0363b1120a4fc7d3b4"
    sha256 cellar: :any_skip_relocation, monterey:       "97e5be4968ad7b25259fcdb37cc007cb39fc53b90194d23971b794e6043428c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6494731dd2d43eb34a5ede5f9c4b1cdf54eb67fced856627a3717a728dd8aeba"
    sha256 cellar: :any_skip_relocation, catalina:       "b7960a5020c6dfb67e35fac40fc5f2ab997f5f470533b4ad1ad5c2aba6ed3ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58812ba8314b08f99291f769e61355705d6717fedd9ce6d588132b25946f1df9"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output
  end
end
