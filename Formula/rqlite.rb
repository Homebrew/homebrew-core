class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.8.2.tar.gz"
  sha256 "51b4441b30ec0650691439e909a03715308d538e915c9d9297f88130e05955c2"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6e393c8041e87ca7df564ceaed79305c2bfd0af74e60a959915d4e470d47f9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f03b11c80f719b0a578a77ad01bb8a1fe033f3df7c18ac27ba9b975af5cd0eb"
    sha256 cellar: :any_skip_relocation, monterey:       "fa30175ca4f9cf355b1a0c5c79c861f0986f75275c2f8c70e4c81148b0cade4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "79f0be9ddfff1f81a2b46e03aa387a22d5544ad5ef167003374c8c90233fb518"
    sha256 cellar: :any_skip_relocation, catalina:       "ddf5e0785fd408b50e6411a35468e7e93dd2c8bd326d2a584252dbf9d5471f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68b79419ab76365bfe9f56524baadf97020bef4608b97ba12d643529c6711951"
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
