class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/v7.20.5.tar.gz"
  sha256 "2c34369502deba166e66cdd4042857a5975494dd7079d86d80f5b283e9ef9ae0"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dd5d2f5b41137150ff47e5ec32becd1a1705387a0e0de6d72399f334de22084"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2101a8cae6930034eb55d84ae5872f79b731e11aaad349662a7d4b782d5a77d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f75af0b13667fb5b359244081d828b2e31d805f247020c74288cf6e7ffcc4b60"
    sha256 cellar: :any_skip_relocation, ventura:        "2eb422184a29993aecdae1c3c70bd6b7ce7c34a0894125cc331252213623fee0"
    sha256 cellar: :any_skip_relocation, monterey:       "e1fa0545fbd914220f2fa30fa6ed2f60d739ac40f1b6cdc4af113cf5a6eef450"
    sha256 cellar: :any_skip_relocation, big_sur:        "62ed2410b09aa937ff5644fd66a2967b4f5a2272a837c37f0c7db273ae73fab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abdb6d8d774d5e4fae8f7c9392125e0a116b36aec8af89e36983ce11c9b0f66d"
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
