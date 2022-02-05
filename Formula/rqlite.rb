class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.3.0.tar.gz"
  sha256 "877174caaf84597e8bd6a0a3ad97efb2239e8200c581ff9d4aad6128ca93c674"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "752823b2d05a21fe9b9618d1d6fc3337eb511c2cadbc7ca3df6cec2e708cb788"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8596100ed921c2f9c726e24825d19d4e80c5c772f97c1ff52196defb5ced1493"
    sha256 cellar: :any_skip_relocation, monterey:       "6efd8a5610a9425e72fdd18ee5cd7e6bcbd492aed170c8c3d715c6c1c89eed5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c5a7f58b3d53891ac9b35cf3c32f4521690220504279b37762c30ff5f0353b5"
    sha256 cellar: :any_skip_relocation, catalina:       "06ae4052328ab89b9085b898bcb73d838b48cb5d8470b7942806a7b919210833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1178190ca21378a16330a50f7e364dd61765ad392e6d8098b6aa17249c8e4e6e"
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
