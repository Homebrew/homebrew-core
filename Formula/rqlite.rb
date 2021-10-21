class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.6.5.tar.gz"
  sha256 "ed6cf773fe09ce419b18e3b6e39a93771608cb2ed02cd842c830fb3f496221dd"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e624556d58fd7991718c9aca90dba52e17bae4978bdb9af8272b37bb52b4bcf4"
    sha256 cellar: :any_skip_relocation, big_sur:       "a991926fd7119a081f1a347b3cb27bad09e5629f22d2e397b5d652993e93da89"
    sha256 cellar: :any_skip_relocation, catalina:      "26450c83ab55b027014aa4c5503018377dc551fed12d16a26beb7abb0bfa3283"
    sha256 cellar: :any_skip_relocation, mojave:        "40c1e7479ab9dda4b505d9909883a9f69e2126e45df19a3ba6cd834eb947beb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a38b989fbd2915a6fa6779ab4702f98d975a8a664bed4237d438b0863545476d"
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
