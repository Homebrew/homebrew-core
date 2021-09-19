class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.5.0.tar.gz"
  sha256 "3710d5e59afcfbecf9a15ea7b6f295a79cdeae3a8e7f2dd88c972c5294ffe1cd"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea717735f6d84ae67750d07cde1f91f51474284be060a383c199756a285ea08c"
    sha256 cellar: :any_skip_relocation, big_sur:       "00611db3eadeaebece04cec49f6af40f294c35f8449a60a9664bd6b8c8440191"
    sha256 cellar: :any_skip_relocation, catalina:      "06b4c536d0e742a79fe4e0e70f64c5ee62eb61923ae4f58ac628d025855c63ac"
    sha256 cellar: :any_skip_relocation, mojave:        "5a8201d60795c705e47565d49d776b97f5ecae42cbac93a32dfe158eaa68456a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd5a218dfeb1d80b296c6d5cb05b788a77c4d152682eaa2a98b7dabda00161e4"
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
