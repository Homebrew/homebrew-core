class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.6.0.tar.gz"
  sha256 "5542ae0a9c70b8227a5893e7043aad17b0f8ce5f6174bed47add4c056e0ade4d"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9ae2e96ec6e9e36cb6b0ec86975bd28807fcf10875fc37e18d3d592a66ae228d"
    sha256 cellar: :any_skip_relocation, big_sur:       "148dcfb487280353a604d8a9ed7ce80a9dc12f222a8be9b643d128798e6b55b2"
    sha256 cellar: :any_skip_relocation, catalina:      "f3b192707d25540cdd4f6b69841f01568fb6f1ae94cba20aa43a20df7410528c"
    sha256 cellar: :any_skip_relocation, mojave:        "ae31f87efd80bc3d73418141b3ac66fd6473568a82a4fc38aa7999700605c320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d95c54ee35af8b9ebee9c1218daeca295e133bfd1834f50b0e9ec10303885ea2"
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
