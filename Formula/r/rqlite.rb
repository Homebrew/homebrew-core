class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.34.2.tar.gz"
  sha256 "ed1fa28f0ad5880a983655785cb9fd1c85c2072fc7383e0fe95f31501dae571a"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a946e33da08ef7b1420503140c4dbfd652a40cd98ad62d8068c8afa790d9258"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c30b176b726ac071e484964d7865ee04b367ceeda1bcdb81daa8ef46bd9abba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dc9b98f5199f27ef4e3bbe537a749ef690543c61d6da819e030c2ab66cce75b"
    sha256 cellar: :any_skip_relocation, sonoma:        "181d880db5199b41e839b367fe160a8ba18a6b1912964267276e16a67107d3d4"
    sha256 cellar: :any_skip_relocation, ventura:       "e6ca834f638033a3872b774a9351f6c4fc5479a2efea3c4f2497521ceb682212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "857382497538301b20d3046fd35b293f130a42556a4ca5a30e5d1f75533173ec"
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
