class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v5.11.1.tar.gz"
  sha256 "7f577fd3ff6b4e2d1cf8557b52782489f9c8638502c1ff8c160ecf4f20153815"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d0d2dc6f79a48b237e1657d9f1a1040b81e75cad7c17a28fe914adfd4f4c1e40"
    sha256 cellar: :any_skip_relocation, big_sur:       "14aa36e999a0d814a21e1728a4c4d534fc7bfd642df271b2b327267fd527ea98"
    sha256 cellar: :any_skip_relocation, catalina:      "2c3f6c3474a845b8b8373543cd5d4712adc4c3d953c457bbb63569710ecf12e2"
    sha256 cellar: :any_skip_relocation, mojave:        "f76378b87164c35617f7658a164ebf23a1335abd106304b657e5c1f899c70cf7"
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
