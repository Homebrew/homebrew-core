class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.7.0.tar.gz"
  sha256 "206dd0838fafea7faaff9cfa96ad659fd65a23c5d35ed537ac5fee532c486077"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b1be7720dbffb7a0266a8ebd914c04a59af9cd37feeb1f182754b4c4d164c8a"
    sha256 cellar: :any_skip_relocation, big_sur:       "4b4a3212a0554db2c82b02f094a9e82459aa6b22fad928557032d57f847c3244"
    sha256 cellar: :any_skip_relocation, catalina:      "ed1305d6fe810ae4ab3f62a6e08eab5498eeb91c051577032af8380bbbc009b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce82dff894b47303c6e14b6e6af20075e05c5a5973b2835da7b8a70dcb7f7107"
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
