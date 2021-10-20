class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.6.3.tar.gz"
  sha256 "f86d228afafb21dad481bf82943d22ca4d0696ad66f4d0efd5bcee1409fbc496"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cfb7193cfb3315d0a12d4e67797867773ebc278271174ce63f544833315c40d7"
    sha256 cellar: :any_skip_relocation, big_sur:       "5d600a896657c7c4e1f6dad4a10208fac01751de49e199b93d0d7e7bbdc8a40a"
    sha256 cellar: :any_skip_relocation, catalina:      "d246cce36dfb71f5c03a0a2bbc876e4692bacfeffc2895d9ee334178a0e45bda"
    sha256 cellar: :any_skip_relocation, mojave:        "e865a3c16c4ab25a7b836218383f9e911bad2f572a3e4bb7bc226a9c08b13856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d5e4ef5756bcebf9825c393a2834651f4c6686a2af2269d956ae94e05c9f846"
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
