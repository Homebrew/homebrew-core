class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "0f54e62cda82d3d939c3bab33480796e77717cba5aee7ea57591abbffa537f3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "30c2e3baa67227f96d15e17fa75709e47dba8e552ea82018a395209a94c927bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "e931485d9351ed4ceb9991e25ce0b2445d3618d7d77676da2cf38ab12cd2f3df"
    sha256 cellar: :any_skip_relocation, catalina:      "b09488b989f6f880a73a00a252168cbf24eef8dbd8906f37ad04673c93ed0d78"
    sha256 cellar: :any_skip_relocation, mojave:        "77616110d2ea5171a040917f375e3d03aff2977699737f19ef31f8196cf6297f"
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
