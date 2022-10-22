class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.9.0.tar.gz"
  sha256 "bd755cc58d58bb5eca66f85b4e3471aecd8ff6a47556fbb8bcd6d1a78d0fa18f"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f876bbb46eca0b774606f5aff9c40d389d357bb196332ac1d0469b490101ec2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "105d7af0612691dfd8717c2dee2e27d90f1b1487ff4c6a95762f36795d0c85e3"
    sha256 cellar: :any_skip_relocation, monterey:       "4f7f4050e4e02edbb606894f243fb076dba1b9e3a2494d9595b9312048d76fd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "343ccd3665cfc11ef35bb7759f640ac073599c6995d7366d9a1856be3acaf42b"
    sha256 cellar: :any_skip_relocation, catalina:       "a55f445adb6adb5b9d091f842b1aaaa2d777eca5a8a5d773b9748e5b51f83d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c7b57f3a44105fbdac1d667fc662581cd2b66b0baaa2b205de4bb66987e43ce"
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
