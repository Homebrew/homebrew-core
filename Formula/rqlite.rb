class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.4.0.tar.gz"
  sha256 "f21abd5b989b6ca7b4b89aee3cd76fede5a3448f8127817ecc8b8507d73180eb"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "684180d25ec92aba4c5177136a650b8dc2abb6ecad660e6cccafe0bf5bffa73d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d8fedae0945988275762c9229f322035c75ecca2b4d0f3949d5a31e2ba8054b"
    sha256 cellar: :any_skip_relocation, monterey:       "23f634e6cc1af68723f9a52ecaf61228d3a653f63ca7ededfe6d107509014b9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7d34743f0ca15f54162770217ff4d994310d4803e956b83bc30c0107637e251"
    sha256 cellar: :any_skip_relocation, catalina:       "93d2e56749e82669916f70320a1ffb35af0d748637c88a442ee5810897df8777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37952743c801246254c1185ecc35d0bf1024df646ec0640d1b5f1cba00e9bf61"
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
