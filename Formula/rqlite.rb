class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.8.0.tar.gz"
  sha256 "9b0d5c749afdc92e71d8817404b141ed416504270b2d188868355d5763c31bb7"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2e716aa8a2b1fc89a41dee288273c1b7e73eddba405a8e8253cf443dcce087b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89857c4c15e3d42a23181088540f828618b178e731ab255f30f5c0e0d7383bd8"
    sha256 cellar: :any_skip_relocation, monterey:       "684e16981202883c08196a6c4085bd63d29071e17f8708e81e87a9be23a49f63"
    sha256 cellar: :any_skip_relocation, big_sur:        "6481fec9f81342475527c13eaec3058e874b0c75b62ca0989f1c613d6b30b0e0"
    sha256 cellar: :any_skip_relocation, catalina:       "77b4ccfa49557c993fbaa3747990ad4ee18f3d61ca6894dd69dfdb7960ea701a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d432c64dc2e6f9f4573f88447145f811d94353dd12b34d05451c932710aabf57"
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
