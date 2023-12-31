class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.13.5.tar.gz"
  sha256 "2a395779b703bb1dd6faab550a3fab99d082c37b13e685ed83f5309d62ae7e5e"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "153a99d9cb25f454d3c5bca0411e555e420afa3d3c073e877b0b0900850ae194"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0f3e6d96c5a919ff51498c935c45906a0132954a01c80a05cccefa05e563993"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f1ebd798871a9d848d3df554dd7efc03112897c790143ed55bff024b25afef4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad2375075874875ef36449d2c79aeacb2143aa5e81c6d27afc59596a28a8b46e"
    sha256 cellar: :any_skip_relocation, ventura:        "840281cc08cb3d33f8fc18b12781b87d0584226d2a7f56ab45db03373e53c7c7"
    sha256 cellar: :any_skip_relocation, monterey:       "62846aa89cc38f31ea755bc74d6546b35e4a1f8261ca9fc02212c7ed3ff9e205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57a4eb905a72514eec3c7145df55d217bd9a3646d172ff18443dff4f22cffbcf"
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
