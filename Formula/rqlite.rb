class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.7.0.tar.gz"
  sha256 "ae25bda002626fb568402304c1da2d6a0bf18a0a6d2ca5e114f2d4236496578a"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18c460f68371e8d2b01848c2ce554cf293fa8473fe7495885dba8f54b7153bcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5093d52c5da5d1377b1d504e2607e1189b10359deba4719568c8c01c0bfe32c7"
    sha256 cellar: :any_skip_relocation, monterey:       "b35bee4c649af3180b29e60b06029ab967f85657c4a1fbf3f291626447a2680d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a276aaffe479903021dfcad883ebbead22c845ab374b07ff7a30a7e3ce1f8488"
    sha256 cellar: :any_skip_relocation, catalina:       "e6216b258f8d96f63d09dfde06e875305d15d00db36cd63a1f3446d196a3ce11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b2262cb6b9fb4a870e8706753aa66811a4744e3bc2d82cb2cf77ac90b83cc65"
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
