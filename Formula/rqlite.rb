class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.10.0.tar.gz"
  sha256 "3ccb9deb7353b212c38f3e3325cbc1c896fd827f7355e9d83b3e1e445efda89a"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bc25519698b03f8d18367701fb6a1703f370cf1372a4d603ec24b78e60357e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42d0d6759c497160a9cf5f6f1637f7f95230bab7c32409ad9f7bb757e8e6450a"
    sha256 cellar: :any_skip_relocation, monterey:       "44726fb3c3d9ae4dabb4b85a1384c5beb1d8331472f19b218d665bbebf6f20ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff4da765e946fcbaf202638496d5758aad1285afc8c18e58df5ccaa3ffd2809f"
    sha256 cellar: :any_skip_relocation, catalina:       "ee3717b67e4dd48a5456212e55294c5a519a781dab38a5b3df5618bc31b64f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1be89bedd0bfd558dd0b45d6dfe1998845de32f98f96434fab5943dac8f20cc4"
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
