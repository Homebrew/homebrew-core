class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.8.0.tar.gz"
  sha256 "53272139d5ea83846e71ff0fc6c564822ee644a7c39a6e8deddd03d9d6c5a9b4"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "057db519fc0593551b411b7a0c1e2874f4d80467994f8bb7923ae34915a9c3be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fae32d6e862b81723514bee75200f7f70e3f6cd8035ae68c2403f82b250c948e"
    sha256 cellar: :any_skip_relocation, monterey:       "0ea0f5e594f2f914b9f8dd560822e3446d4b8720356bbd1c7479155f7e00b997"
    sha256 cellar: :any_skip_relocation, big_sur:        "40a06da1306ed2ef007f22a493d3243c7a610ff30dcda934b80c08efcf255b62"
    sha256 cellar: :any_skip_relocation, catalina:       "6b519ec83ea898489c155e2345444b56193f90b4bf92adc6bbe228ba632d30da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "096bb703d9c787f4171d5f2125d8dcea3d5487c8c680885a0edd9e10e463ada4"
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
