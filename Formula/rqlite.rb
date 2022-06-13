class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.5.1.tar.gz"
  sha256 "4e4a38f3ba5a91589bd2424f340d8cf0739715d27e1c41eb615dbc7fb9e834ec"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bc61ce23cb6c72c432b5415705ba8a9e945337d52bfc52c235e10970551c910"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c45ae943db3a61f700a405d549014ff47546b24f21d96e50a1f56c4d3d7a000"
    sha256 cellar: :any_skip_relocation, monterey:       "83f4f06d966288c0d0dfee93acfdb054321961ea6b0bca587f4da8d251eb4050"
    sha256 cellar: :any_skip_relocation, big_sur:        "87859a17130bad362215a583423db95952cb1dd63396c491a3d3c0865178dac9"
    sha256 cellar: :any_skip_relocation, catalina:       "1f2e8cbf359cb253f930399549251f91cd598bda6d60890f055b6d98ffc892b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d752bc0c5ca47189c7f952df98e54cd2566c0517e342892691b947361037326"
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
