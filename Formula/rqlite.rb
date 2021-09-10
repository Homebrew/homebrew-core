class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.4.3.tar.gz"
  sha256 "ee34004f916cb9fad4d60199c930d1c4e7e8f5c8b2b5c55276f53b71a160f9f5"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fab79787ede7d425ac044e1cf835a925379c7894f8d5688ea5ffacdefa37e2a9"
    sha256 cellar: :any_skip_relocation, big_sur:       "1c06e403625feab3406737c1ad8e6000dfd1722086f95c15a5d9c953a2c25f52"
    sha256 cellar: :any_skip_relocation, catalina:      "69ac5c873a129e2beb30e6004b587356a2759dbc2375e0b18185776b92ae8d6b"
    sha256 cellar: :any_skip_relocation, mojave:        "ec58f2da0e500e052c5d56ff686e103628ae3d0c9c40dcce4c6b15561b19f228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26b0fc2d548fc83838ae3502b2fadbc9e710b4390b922d178399af94b6f0a57e"
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
