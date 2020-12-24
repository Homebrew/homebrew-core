class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v5.7.0.tar.gz"
  sha256 "62a7f20302dfcfddbd2c1d84a611ab7907f51540d8ce80894314627bd7b6cfe1"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ef411708aeb12c680ea3fccdffaf273ae3d273d4194ef91b33b5c77dbb8d13c" => :big_sur
    sha256 "f0c78b3597ead1b27b52dd5048740b50502f78b37328f79ca22b48a93bbe9f74" => :catalina
    sha256 "ea8e6650593669d12af348cd4f1083f584bf0c2842c7cf6ba5921ec4068c223b" => :mojave
  end

  depends_on "go" => :build

  def install
    ["rqbench", "rqlite", "rqlited"].each do |cmd|
      system "go", "build", *std_go_args, "-o", bin/cmd, "./cmd/#{cmd}"
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
