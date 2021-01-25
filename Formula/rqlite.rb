class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v5.9.0.tar.gz"
  sha256 "b40302fc8497c8253c38f51f8011b0f5fa6b005115efbc229764215d10b461db"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9955df050da0517060118eede780f7fbc55fd72a068a3fa8e14b044969da1998" => :big_sur
    sha256 "625c7bed280292e30d547784a430f030dfaeff33904c94f2197bee60683bb0ac" => :arm64_big_sur
    sha256 "413c956a7c61fda8226b3c02a6669b2aadc65a8310cee62b4be0d6f0a94ff875" => :catalina
    sha256 "20d4d9060830447d7606e6b5f778d869b2717b59e1ce157a95fe660b83043062" => :mojave
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
