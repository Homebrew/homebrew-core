class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.32.3.tar.gz"
  sha256 "89bda92d68c5e4843d3544b619dfcdc5a9a7575caad564f72bbb444524ffd11c"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e671a89a78e57692d3cbe292ac86b063cf98f6eb1a96b8f2115fe3a1ade335b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d4fb2952228c103c1e625b5eb8693c015fe24931475174ec0f0f327be20a119"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05148048daf188d4e98a8dfca2dcf3d89756bd7586f34c1962fa01cab2d2c0a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "da612880e24b816b70dc566601c60748afc8a2bc094f712b21a67850d812637c"
    sha256 cellar: :any_skip_relocation, ventura:       "15a3f63f6d2c1c105f3dbe99ef44ae4c0a9602044b4f1b0b74fa647a39bb2258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "942adbfeba1a1080fbe60ad57c87f6a7dc841ed7fa275063412ba3b0ef87b040"
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
