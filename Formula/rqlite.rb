class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.4.2.tar.gz"
  sha256 "45241ad1d0903177c8ede58e0de65b50e0084fb29fcbe1a3917537d7bb8f13a9"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "567d16d9731ddd548bb78830ad35ec950a809fbd55ec14cc372300083ef18b34"
    sha256 cellar: :any_skip_relocation, big_sur:       "e1d392d317fb1ceb951aa9f8c8020337ae07196fb448ecb98e1955f8d79a84cb"
    sha256 cellar: :any_skip_relocation, catalina:      "4d80ddec2aa1a29276f8a7cd1f92a09ddeb04b5933fa58233f758d5bac7fee95"
    sha256 cellar: :any_skip_relocation, mojave:        "651db07333db9faa5c42a8fb5fe4b677911688f94e44d4b3e16cfc2576b30f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dd76d6f443c36b0cfb2b47fadece0ec81a1b78992fc1d342323a24c439c319f"
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
