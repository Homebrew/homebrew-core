class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.9.1.tar.gz"
  sha256 "995ebf8424907ed5adc093c6a56b3a87b193b9b60d6d2dcfc5868892f9ad93e7"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e0e1a3cc262df88c34f07d0c3bf83f8c16d0d9205dc7a5b0af8cf10d1d509f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8cbc07855115f81232b95d13527a085e500ae33905e72cec20d8e25cdf63563"
    sha256 cellar: :any_skip_relocation, monterey:       "e7f0a6cf758138227b280b07e802ed735d5f868e1342590255cb36c39b9af02a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1751a69dfdf4789328969566b85b9759caaac5803712871ddd003ecae096e9fe"
    sha256 cellar: :any_skip_relocation, catalina:       "af4bd33f1fea55908c5f68d922f3b885a51dcf4ffcdfaadee7ab75f751c19004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ce3c23e2c72340410105e637f3cac5ef7beb76e923f1cf0f7989e90950fb113"
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
