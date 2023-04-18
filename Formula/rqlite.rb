class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/v7.14.2.tar.gz"
  sha256 "b84e4bf29cbb1f36c194655e9b69e4d2e7c20602ecdef119a99d1fc9932d4ecc"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a378b6b5d6f894d521e6c0d86e01fb0e8228c9c8002b79e14f82590c68a1a6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42bb0705de09190a0d326c887a651ac1046c5a8408ed7e338163e203b89b9239"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79c954b14814003f45ea52ba865a8b690234801da52752db7b34ed55f49989e8"
    sha256 cellar: :any_skip_relocation, ventura:        "0ca812e23fc95872975d63bb667e7cb5432c4a131808bbf748f2558f1e22968b"
    sha256 cellar: :any_skip_relocation, monterey:       "ae7d0bcd9e6cfa6dcb43728b31887aed60fc60aa685b377d38fbcec2d39a4532"
    sha256 cellar: :any_skip_relocation, big_sur:        "180fe115345fcc15ab9ea586a8ab0490a1e39d59f2023ca526635fe7f64e078c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d5efa9741ed1654af78404ff805bcf58750ec19f999b0d4a08657ce7849e499"
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
