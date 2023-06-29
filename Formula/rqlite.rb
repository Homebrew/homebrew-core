class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/v7.21.1.tar.gz"
  sha256 "18e10943d7c254f50d6ec831c017f85620ff6e15db78556171ea3585e7820a90"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70053407e0e14db6c98bffb20e1fa7ccf4ea32bf4895e421e4215b80b417cb18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9da296f2404b07c72a63a7ab8c84b388c58ed3058f7c2d8d5dfd5b98feebec8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f03be418b295d7c6bff29903df5806b62273c4f6af965db2676a4e36f817c83"
    sha256 cellar: :any_skip_relocation, ventura:        "79283d46900e3d123374cd564070fc1bb1aadda8313cdb3f23f90db6acca16cc"
    sha256 cellar: :any_skip_relocation, monterey:       "417d8a403cdb77dc248d82df3f587de6fd45336d11219fb4607c3558ab46586f"
    sha256 cellar: :any_skip_relocation, big_sur:        "03e1250e7a8c0ca229823f1dd468908de7a45f53ac3f1dae4c597076e1f1e11f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9791eef6eb8f29d34bc3ff9b66126172b500c9cbbb4d24055137b7d4150033bb"
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
