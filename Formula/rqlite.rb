class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.13.0.tar.gz"
  sha256 "0adf1776a5b8d9583d1bcfdf28e3f92d78b33dc8dbf094af75e6b60a02993865"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b740273d49a25add1506f0e5aef6da2b52f223535a399f0f6775430a7502b72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82158e129938686143df4362dd2c32c30aad83c1df9df456ab3c43168b7822b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "932429ca5f792be074716295b010890dc2f6d4da21e29029610733234fcabf8f"
    sha256 cellar: :any_skip_relocation, ventura:        "f28de2df5940600c07f51249c2c36f6d924433bbf812324442bda841f3a94d0b"
    sha256 cellar: :any_skip_relocation, monterey:       "e5f9e4dc0d903e7612db94574c1b3e218ba9f3a26b1bff91b7179cdb130111b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "21de4bb1ff281a9b2757b4354ffc0821834565ca5d17218e8664a48474cef2a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "476843f6096c4330750dd1264774e6b65e482b7467013fa1074d4bf62c555c0f"
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
