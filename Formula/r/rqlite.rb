class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.23.1.tar.gz"
  sha256 "37b8ca4c98db2092e5a5d748c4ed6c1e883bd5fb7e410b7d3d6d95cf45bc44bd"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c15a6eca3df521a32706870e3008b42f1bf97ad3e24ffc09ed622b94b1d7b21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f28995cf694293f5a671d9d9486fe30ba27dad5a91306e4f181e6057ee5a634"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ba80680948a546fb85582bc737c06e4686d160f34bb8da511a0d5d233ecbce4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4dea869112f5e66805d16924ad13a0481245ea7b351ac83025ece6d9bd9d074"
    sha256 cellar: :any_skip_relocation, ventura:        "a385c17ec3b2a9310a8f0390ab39e8a8e7fc60200ed97595728e0e5614dc86cc"
    sha256 cellar: :any_skip_relocation, monterey:       "5c2304e077cf2876f2ec8911d029d1c49ec42699cd2abe013aadb18ee72ed7a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "164daace774d992409835b6b65ba9638156f04354f5c67a4872dd300300504cd"
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
