class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v6.0.2.tar.gz"
  sha256 "e8741ab5f8422b99132b7614640c60a69040c8049a6b85b8eff05b3fd5124bbd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "69d4c56a8211dc57681dc198bebf4b55cc7af5ceafbb6c42522e82e69495039d"
    sha256 cellar: :any_skip_relocation, big_sur:       "ece063a33ba0b98bd5151901a9d583506fbeda4d7ee09fca1f3070dc820945d1"
    sha256 cellar: :any_skip_relocation, catalina:      "89d2ce9cee4450737b86fcde997a32414af2069dca073039d68c7f82097873b4"
    sha256 cellar: :any_skip_relocation, mojave:        "d88b09b9fbed83d88d56a0e6a40dd9ee3c65dc1a27df52cd4065d636257516bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74fa5c15fc75d600f08585f6e90ede990e398efb0b993cac3f5faa6aa26a62b5"
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
