class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.10.0.tar.gz"
  sha256 "e70440fa9a666b4d33509f1d53e8726f3999a424423aac453edd5fa05cd10114"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5a75a5ebd56ddfdb687a9bdfc6d0349ad9272a344a4bf0f1081e1fc926ab86a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d39ecdf0a986288258d3475aa4a5dc889a6ecafcf1d059410b9b6207c79cf75b"
    sha256 cellar: :any_skip_relocation, monterey:       "cc144a13fcb22ea41f5d2b585168532debb29482f02bd7c0d986988a2156311d"
    sha256 cellar: :any_skip_relocation, big_sur:        "33b7d15184908239d2a0dee61ba10370c2f11fc18d6eaf4f16e382947970900d"
    sha256 cellar: :any_skip_relocation, catalina:       "d757348938cf65d5cd0c3f3963085f447657eca073664ae906e09d9ca787fc60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "546206e418675c655d36be84c1d81d3840658fcc7c519e9aedd43ff5a2b504d6"
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
