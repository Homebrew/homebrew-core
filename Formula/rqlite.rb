class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v6.0.1.tar.gz"
  sha256 "3b6dc9243a1100ef53106c241aef3077b7647818db10ff40c3bddbdb10a2f6c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aed386eca23f377f9afc68d3fdd47b25353d9f5b20ce4b3e698beeffad9d8f96"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b46e2aef484b465fc288650a243f06ce5e7703f61326ac1825f5c13255dda1c"
    sha256 cellar: :any_skip_relocation, catalina:      "a57cd4b8df7a0136ca3041cc2ac88439e1741793a3fac69c9481f9bea86f97ed"
    sha256 cellar: :any_skip_relocation, mojave:        "024a784680c498b29147fd4144ff477bc63f021fe475790325b29578a82ac0f6"
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
