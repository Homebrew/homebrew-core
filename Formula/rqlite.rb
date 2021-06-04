class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v5.12.1.tar.gz"
  sha256 "2156d6fb4253fb6018ce2f78b0f6632256e2ea6259774e3ffd89a3250acad4c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "30c2e3baa67227f96d15e17fa75709e47dba8e552ea82018a395209a94c927bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "e931485d9351ed4ceb9991e25ce0b2445d3618d7d77676da2cf38ab12cd2f3df"
    sha256 cellar: :any_skip_relocation, catalina:      "b09488b989f6f880a73a00a252168cbf24eef8dbd8906f37ad04673c93ed0d78"
    sha256 cellar: :any_skip_relocation, mojave:        "77616110d2ea5171a040917f375e3d03aff2977699737f19ef31f8196cf6297f"
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
