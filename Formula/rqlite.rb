class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v5.9.0.tar.gz"
  sha256 "b40302fc8497c8253c38f51f8011b0f5fa6b005115efbc229764215d10b461db"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd60ce50ba7637aece795274f855b2d6d6aad0a234279ebd5fdf262dbe45d10f" => :big_sur
    sha256 "b32254c8497d1d16f26c7c926fe45c7206d4a1773c4159a386511ae0547d547c" => :arm64_big_sur
    sha256 "21abe21de2554edb8f0e304c94f382872309703a9985f47057f25646b04f47d5" => :catalina
    sha256 "ceb6c033e3567d4a5d1b858718c93d4c02dca179ed81c7165dc8b02880ab8e1d" => :mojave
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
