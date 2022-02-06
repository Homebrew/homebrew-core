class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.3.1.tar.gz"
  sha256 "8c87ab16835debab34d355895da598ce193e30d2c4af22d73182e3f4eb04a338"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d16a0bdaf25d130f1ca3e44af7574a615070d45af644cb4f645be707fc466085"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7a6d08f835cc6b7dda1e449106408a06812841b53f769d0f6c88c5fabb314df"
    sha256 cellar: :any_skip_relocation, monterey:       "34a2c289c0ce9083fcc7e2ac12d4c89d71ed65f853d4168b8223ef981b5d327c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf9123433932aef8a03b7b48ece01c4c286bb5739e78d2837ace92a2923314f0"
    sha256 cellar: :any_skip_relocation, catalina:       "bb4c5889634642ebbcec1e1b86de936b16ffc39e5a9c63c28d2a3904ae396508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "584fe2d406476e408d40fb7be39cfb9a822b01c9950bd39a86d36cb6f0f4caea"
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
