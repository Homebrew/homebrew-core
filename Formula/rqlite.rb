class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.10.1.tar.gz"
  sha256 "a0a38ffcddf14883a37613c0654a4135c04f20d069878f5553aef59836d73dee"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c349b48c7392090ad8461ba4d8818dfc7ec5e57f7b6f7cd14c0c5c9dae9d12f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b028bb7f7ca9383e863d562c5cd9dd94144362e8bbbe9a8adef6177aa07863e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4745109702a5ab8174b16d9bc468b2b329d4bc775afa89c8a1673e2ea0676a3"
    sha256 cellar: :any_skip_relocation, monterey:       "1d39d21cbb5768540f98bad7099edd8c8b22753f21fee33d5eed90b847767612"
    sha256 cellar: :any_skip_relocation, big_sur:        "de0330746530345486c9ccb0ac4692772464276592d2afbe327dfd168f3c6e5b"
    sha256 cellar: :any_skip_relocation, catalina:       "ae244e39751b268eed49ae0dd51f8f73631bcb1c03f10ebddb93f59aaf8e1656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bd71ae14a0324c66328bd4ff479d312a5ae5ab085ec869ce6bd5c595e039ac6"
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
