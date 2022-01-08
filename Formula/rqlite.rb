class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.10.0.tar.gz"
  sha256 "e70440fa9a666b4d33509f1d53e8726f3999a424423aac453edd5fa05cd10114"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14cad2fc7267f5675cb8595f6e4edf8193c95a48bac322111bc6909e7bdf35e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfe22480202b7922eec0a4f0618ba14a1492e2dba9cc533e6ec78183bcb8350c"
    sha256 cellar: :any_skip_relocation, monterey:       "0b2927e8e773cd5d290ad3f1586ba020c1fa862c1b2d2faa48b5348f1f514c41"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd0db8857ae1dc2bcfbc938f20488f594a3dbb8808b123a27646c8cc7ab37ea4"
    sha256 cellar: :any_skip_relocation, catalina:       "aa61081cc7d63bed274f0d81ba0dde75d3cb8d45a92f30120bcc84525a74b76a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbfa087a92808cf024af2363720c15483ed89b2afb3b4479bab3bde895919a02"
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
