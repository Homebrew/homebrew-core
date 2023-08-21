class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/v7.21.4.tar.gz"
  sha256 "f5443a90c85f5240ab25788004b9fabf24252e1ae455e0d63282b5ccf9720606"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f11316c819c28c613eb60b0e35cd9da6f2f8262594e139f469a4cc8a7ed7cf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "388a7f86b4366f72843b46e344d679eb22c37bbe6b9e7398a356f97916603436"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bf8199e7307c7530af454c272fd974c644730734769b49b4e7ed76c635763e0"
    sha256 cellar: :any_skip_relocation, ventura:        "2445dc7289cf1e530eef1749d56ab6501ae7795122d5d285d4d8604fe4d84880"
    sha256 cellar: :any_skip_relocation, monterey:       "f14609c797381883fb3559da1525ccdbef3e2785a16105ca093192b650567727"
    sha256 cellar: :any_skip_relocation, big_sur:        "e84b5b222809e6a5d0d0b50879bcd030a94a969f76726937a5ea641cd7a1c028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e876ccfa475fe8871183794cc213e4bb0d0b922de565f63ed12d0e9add0571b"
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
