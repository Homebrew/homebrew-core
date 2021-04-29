class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v5.12.1.tar.gz"
  sha256 "2156d6fb4253fb6018ce2f78b0f6632256e2ea6259774e3ffd89a3250acad4c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62986af17fe64d46b6aea5b4611f7159e282e2c59865b40ee0c0284fcd75ca55"
    sha256 cellar: :any_skip_relocation, big_sur:       "993f8703342dd4485b621002da33c6005e80a032d63d21478dcdaec9f1f0b86c"
    sha256 cellar: :any_skip_relocation, catalina:      "89597244aa31c497bdf768cb4a0a8bba48ad0452a008dde27a60d83d65dbe81b"
    sha256 cellar: :any_skip_relocation, mojave:        "d4f5d52a72501b57f5b1029b78ced3625a6e3a2eaeadd31749c5084cc3a0e96b"
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
