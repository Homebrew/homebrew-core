class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.23.4.tar.gz"
  sha256 "cdebcb8990d3ded582ce443a9541f114c83efd970e301d212024beaff336d036"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a542bb88dc7aa79abd74ce81006f8b28b1340b85b2d1e3b534c93ebd093314e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c6362bdccacc1d3f2e576ad42d0e2ba0dfcacd8d91fdde6dad280b8e01f6574"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac7c401f64cdb6d5b4c423842441a5c4ff5d5ea762863e507029be5da986b4b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "468e85a6806694fea89566a965039e6f3f63974bc3f77aaffbaf51162dfe41d8"
    sha256 cellar: :any_skip_relocation, ventura:        "c681151dfa9bfb5ef84369787165326e668d810366356c80fdef05471e37b8c3"
    sha256 cellar: :any_skip_relocation, monterey:       "ba159730cc8cdf8c10ac4d7a9b24617833323aa5c5f8429c848ad967d45e8016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e9458834a2e4a475f51cc24aa4b199cbe989bc1e884978b3e280978d930dff4"
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
