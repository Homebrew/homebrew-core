class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.26.0.tar.gz"
  sha256 "2a1e719515300e9814db3133b8585e8857111338b94e7c94a8f6f775d7b07f06"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a38c0abf1610e69136a1c706f27eb7024ea905db5a7c8f3a54b10309c8ea010"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32f54a1343c118872c904169efa7b3da01281c2e4fa53c8dbece5e9d6bd25ae2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5603b470cb0827dd9e10eb9f88f586869d4987d58177478712eecbac58d21c95"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d5aaabf0bc5d42b9b1a58e10822dd00b83205fcffc4c68000ed9fa39cbb7507"
    sha256 cellar: :any_skip_relocation, ventura:        "2901b9ccde48458c319059fd7b56f3ec859c4e1327163930cfd961fcbf20bbdb"
    sha256 cellar: :any_skip_relocation, monterey:       "d74edc3f7cdec9cf43e043a8e6a757be812f39c822c58cc2518d53040d025819"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbe352ba0e0adc12ad4ea45f94f1f74dbe9a550b10ae9b45619796c5055e58e3"
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
