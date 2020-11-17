class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v5.6.0.tar.gz"
  sha256 "4cc030f25b4611c1b51f994dbca0cf39d0a6072d8fa72e9f4629e4b392233684"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1890fe378a89b14fbc174a3ca2b91546a02b06823e7315d65a5792793fa38dad" => :big_sur
    sha256 "c87f637a07a3aed0bb62102cad1fffc1e66450542bf1647416f5984aee76cdfb" => :catalina
    sha256 "64f576469e3932b1a0dc333309eac4d815972d7b163fa2d64920b0f5ccc2f5f6" => :mojave
    sha256 "6f7c825792e443a28ab231b7d403e628124939312828b7e098109e5f5fd94839" => :high_sierra
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
