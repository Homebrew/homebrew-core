class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v5.11.1.tar.gz"
  sha256 "7f577fd3ff6b4e2d1cf8557b52782489f9c8638502c1ff8c160ecf4f20153815"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d3dd360988ef54441bfa090c71b32294bf76df7a0eb7a1a69e0d1e7d803c9f36"
    sha256 cellar: :any_skip_relocation, big_sur:       "e71df6cd1858c721a2eb4e98d668c16bd280d6feaa68f4a1047823fb23841495"
    sha256 cellar: :any_skip_relocation, catalina:      "fd38b634ef7e878c3b2b9a68d21afb8885731280fc5b96e0fd0c5415b5de4e3d"
    sha256 cellar: :any_skip_relocation, mojave:        "e0e43dc4463533c9193e54d3fd4344f89c728772155bb1ac99dac92d01794675"
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
