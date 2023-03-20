class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/v7.14.1.tar.gz"
  sha256 "800f2b20f6ad3f536ddc448e212df08e9629919aec9624afd48b2b97552447f6"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d1572b6dcae7d5fc6ed056ff0fab92b5b78b783553273f73175c3353f809ee8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6537609ed7c81a7a82d92b3fc8c5be4cfef9c8882968083be9c4a26c19c41492"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72f47c1fd17f070964be9d7177477354c339b1e3aded39645dc268d350d9c605"
    sha256 cellar: :any_skip_relocation, ventura:        "c264382030e1a0a4b95598092bf4424c1bcd9613a49d48925e2a3b09568b1a63"
    sha256 cellar: :any_skip_relocation, monterey:       "35667ebdc5598df7823a89ca737ac2d465b067c067c98d5cd5b7da5276f2cf23"
    sha256 cellar: :any_skip_relocation, big_sur:        "f842ca7e08491afed0c559f63411a17dd2013a53b3d66de839a7fed4417e683d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80e7bc5f455fa8045c3c6f827fff4ff2e3de8931d0b613f46b6bf376267ea8d2"
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
