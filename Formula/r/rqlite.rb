class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.31.3.tar.gz"
  sha256 "ca93f258d6d21e338335ff1924c8fadf3f3324b4d61aab6bcd6d58463885cabf"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5baa008b4874ed5ee3b50069969c251a2512fbd5edc8e8abb607195c55999fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "155ddc0b12c14cbb44bfff4ada158c5bc6959376c5f243083c946a5415a3434c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76cf44b69891ffe7051e9ad23e43f688c628ff800e53742c17c7a7e054b38d1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1a5833fee2044c837b3fca7c6383d49224cc353307781b8c2dace43f92801e7"
    sha256 cellar: :any_skip_relocation, ventura:       "6301e7928393457e5e668e4c527b7da1b8f0d79151d6142971dbabd3ce445460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae1cdcebc8466887e2d07ab1c8789773d614877ba05e927885a834d89de79715"
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
