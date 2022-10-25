class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.9.2.tar.gz"
  sha256 "614dd69b155c0335af97bc4706067ab91415b8cc795635cda047ab1b1580634e"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd5332b8d47cd4bad9394749b1058bff861ad0f58a0d824038f0dc58cff6deb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53d264d704b40aae9db0241b04c01aed89cf793ee907180d81d7ddb5fa895567"
    sha256 cellar: :any_skip_relocation, monterey:       "7e05a60a142a52c42c57549d0a6c3b681dc114279e9ade7c7a5b8a94ed381ef6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7b37f5fd18e45590fce68974ca9137ab9f7d01402f8657fe37a32a7e3962259"
    sha256 cellar: :any_skip_relocation, catalina:       "a1b27b12009bd621065684258e4189c2cb68eaf4979ceae770d0bf5055b5e013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e455fe271bd2688e3953f40c56f4c7db764086b2057676a41e4dec177b8f3a04"
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
