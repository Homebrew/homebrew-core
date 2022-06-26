class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.5.1.tar.gz"
  sha256 "4e4a38f3ba5a91589bd2424f340d8cf0739715d27e1c41eb615dbc7fb9e834ec"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73070c080a1571d5b5c16ae5011d948f5129338fe597d69fd857919f4352b43c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b0cdbf478f1a67fb0e2b206cd0f3e79169f5c5cb23ab69a8063074ab1e22dfd"
    sha256 cellar: :any_skip_relocation, monterey:       "d2a1b0651b1b87f00586ad093eed771c32748471bba83a663d67b7432d793b19"
    sha256 cellar: :any_skip_relocation, big_sur:        "b20beb4998f634445e1da5e6005ef573f84a2db24cbf1cbb7e0ecd6a2fb52a6d"
    sha256 cellar: :any_skip_relocation, catalina:       "736c93791da670768b8dce0bcf25a7a155f0ac7ff906461b5d1eb13b9ef0fde4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9efd1d71fd127632eb1f22660628146199002c4c4db8a369d292bdaeed268b15"
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
