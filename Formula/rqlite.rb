class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.4.0.tar.gz"
  sha256 "bfb6c2ffbae317973882e3b7a8c40d8f33e609864c19cdc52cd214de2cdd966d"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3bc60273961953f840d9800a09f6548d45e8828f98704212c1240ced871000ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "da8bfc52a2281a7775510d9dd9efb6417d057eb03d8539b080cdb68424265669"
    sha256 cellar: :any_skip_relocation, catalina:      "8c7742f0d1c619a03a29e2340e9e8d8c4d389d2c5fc2e330b3c95914b7c7189d"
    sha256 cellar: :any_skip_relocation, mojave:        "e68db573b5223e523be475a1babcdb1cc5a8dedadb0cda8c3b8b7fb9d012226b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e26c2c9884e87b5cf91cd67f6b8f253736cc6bc1307541ef3ba34721d8770e12"
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
