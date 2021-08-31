class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.4.1.tar.gz"
  sha256 "8e42b8add4b7bccabdc43e6c291ad4e8ff9fbc8ad1568010f3c45f7ef22f2c09"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9bacd23e2367b4e51fdf3dcb3a55173751e1829ddce3734e8020d672c4a800b0"
    sha256 cellar: :any_skip_relocation, big_sur:       "2ac2ba940ca7a3b4e1e6e02823bf4820a12e3f49bf7d2a6febf08dd4fb66ff6a"
    sha256 cellar: :any_skip_relocation, catalina:      "f78e7a559a44cb937407c9192c043947734f865329d1af298ceff3357f86d489"
    sha256 cellar: :any_skip_relocation, mojave:        "a37b63da450742e68623ecc3ba4ad2ca865439470b29f98c27ca994a626191f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c374527a9133267e88d10aa66d39099aef6e8c0073b3414e79b53e1cb5561471"
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
