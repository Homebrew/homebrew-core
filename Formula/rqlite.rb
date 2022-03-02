class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.3.2.tar.gz"
  sha256 "e07aa277cd60adaec45890bc4daff691c3016faa9adf9f3387fa109c229bbabe"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da57791c831046086c5b114b1503f3275ac0e50c9f399497e00a1fc459e5a3d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e6979b42ce14193714f9032754df50bef69acf609cb36f4076c6bc741b493d0"
    sha256 cellar: :any_skip_relocation, monterey:       "16ada1640bfb56f67ff294b033c8090ad5aecc74532dfe4ed97e7f7c01c71d34"
    sha256 cellar: :any_skip_relocation, big_sur:        "3271fec2f884bc9633c1f8311620f2c98b41ff743c203f92c513c6fae6b8b363"
    sha256 cellar: :any_skip_relocation, catalina:       "367b6553d937658104e5229fb455518c490ca1809fee83e9e225d4fa57ba67ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e80d64504a5d2f059fd481f94ae93a65a3a0840367c5a6846c0e8f1cb4bebaa"
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
