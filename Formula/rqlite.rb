class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v5.10.1.tar.gz"
  sha256 "0d92268efaa97ed2c3f5f07c0926be47973b3d3c68fc1589d654c020c08e0989"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eac64118d82bd4d2c943e1fdd76008868f37d909aa69c1abf59b0ab917036aa0"
    sha256 cellar: :any_skip_relocation, big_sur:       "0be3e44ee0eba6828cbdd6b1a28f45d244d253a6be7da225cd2d8bf212ece668"
    sha256 cellar: :any_skip_relocation, catalina:      "a40fb06221e9d6c562d7fb88ef1495dd1b93c128108bb5f95e255d4e1ca4bd4f"
    sha256 cellar: :any_skip_relocation, mojave:        "1ee363cc9a45f143429b2590b93827ede0340eae34b073878758ddbb368f676c"
  end

  depends_on "go" => :build

  def install
    ["rqbench", "rqlite", "rqlited"].each do |cmd|
      system "go", "build", *std_go_args, "-o", bin/cmd, "./cmd/#{cmd}"
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
