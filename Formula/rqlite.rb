class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v5.10.2.tar.gz"
  sha256 "510f9a0e0cf6adfcc88a0d65273b82d6fb01722b63e5f439cff7e8b802dd24ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e9605fc91d586f7bf474f708b5b4c1264a82915598bdae21a84c726013f15c3"
    sha256 cellar: :any_skip_relocation, big_sur:       "6d419ca2817c547658cd986f81b86651c935a71f5e26c992f2067c0b3991782d"
    sha256 cellar: :any_skip_relocation, catalina:      "e0a5ef770f0a24d08cbfb8b2e2fbe5b01312e797842c642aff43589536c92b38"
    sha256 cellar: :any_skip_relocation, mojave:        "3f425c5b80f7603379d01e3ac7cde73aa4b2f07eaafff6c398947c6c23a091a3"
  end

  depends_on "go" => :build

  def install
    ["rqbench", "rqlite", "rqlited"].each do |cmd|
      system "go", "build", *std_go_args, "-o", bin/cmd, "./cmd/#{cmd}"
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
