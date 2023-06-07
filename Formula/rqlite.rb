class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/v7.20.1.tar.gz"
  sha256 "2f1eb4927cb7bfcfd28cb3e166418a7151f1d7df5a9e9061a6853f95889cbdd7"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d7e1460c96376632c995ba6d07877a525755af9013ebaca5ef04b86f196e93a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "420b973e14698a7b6a2f3b51f312fd7f5b65508305ae8081ce7eed2ec92d2682"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63a02ceb350bd3b9f845e832dafe7d9fa239a1b48c195003e6544fc260a80eae"
    sha256 cellar: :any_skip_relocation, ventura:        "4bdc591613d72cdc6ddbce27a6126466a4fb602193a226f5b01406c314325146"
    sha256 cellar: :any_skip_relocation, monterey:       "34c99fd65a50d8c03f32cb764faad55795de1ee4ee6d1a3b1770a387d6772634"
    sha256 cellar: :any_skip_relocation, big_sur:        "0295cc2583a982b6ea1af223b771e7c9b8bcb5326bda8bd4bc7d679244be2258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4baf8aeaf2a04fe24be0f2c883d235d6a130a1e97905f3cbd66c3a72cea91f1f"
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
