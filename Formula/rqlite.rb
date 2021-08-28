class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.3.0.tar.gz"
  sha256 "583d9116a97efe2b631cc4a2545fe2b502d3fcce8da45ed3cbb1cfffdfe4ec9a"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ba0773f8a83a953c95b1be69911dd1355fd18d2078e83dfa2ff1b898fa6fb17f"
    sha256 cellar: :any_skip_relocation, big_sur:       "77ddd0edad5a5b08a8481b353665d5617dc1a6fa2bd0dec01dc35e81e86167d2"
    sha256 cellar: :any_skip_relocation, catalina:      "d1e54dfc53058080d8c02403a93bce0eccc5b419debc62406ee5620f8bf6cedf"
    sha256 cellar: :any_skip_relocation, mojave:        "b6ba98eb64ffce0e3634a1f266c24e0f32ce3261f7a1bf6ec27d20d3680b602b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd7aee757a6903e0783b834fa7045f9d591e7ff3001a292f2cebd2b46fceb4ee"
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
