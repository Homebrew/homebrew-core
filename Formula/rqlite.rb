class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v5.4.2.tar.gz"
  sha256 "9a78542b72883e6452029500d64e6234fc719aab4147e240476c3f7a4ce801a6"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "b5deabda22a2b0095c729ada9d78a76d82eb55d45cb6c8bc5551e6b3d87518af" => :catalina
    sha256 "32b7fef757fb78506236624d41e6946821ba7e0fbe11b46da25a670668525168" => :mojave
    sha256 "0f8367245c0042a18e80b6791db68c8603868611a7a1b723e6f6647e153aa458" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ["rqbench", "rqlite", "rqlited"].each do |cmd|
      system "go", "build", *std_go_args, "-o", bin/cmd, "./cmd/#{cmd}"
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
