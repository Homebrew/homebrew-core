class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.10.2.tar.gz"
  sha256 "bfa9c6ac6e64191bf281ba94481dc613a38305c8f4bc64a1350b7f59e109d510"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "060356f0bd8b7ab8dc0bbc6c3fa8c980029c0c5facae8d3ae3b8abe96d48537b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc6a2ae8c012adc2e6941eb1cbc4d6c28f2a3bb427b2c1b4f1f66cb913f0c7ec"
    sha256 cellar: :any_skip_relocation, monterey:       "42bc73a1d3cb867df784d418927df70fb5d3cab4d3327e4423fbfcaa4c389b0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e2c52d67eea1571766702253691a65d8faba19d65e6c348b83dba5de58b86d5"
    sha256 cellar: :any_skip_relocation, catalina:       "8beffdefb58df35286b142199809ebca2486146d97446332fb841fbf77a6ebeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c2a11b3764b86a967297130c32ade26725eecf4c20bd4acfd97f6462817262a"
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
