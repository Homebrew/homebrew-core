class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v5.10.1.tar.gz"
  sha256 "0d92268efaa97ed2c3f5f07c0926be47973b3d3c68fc1589d654c020c08e0989"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c2287d09af6299df300f9d24e894ac63f3aa86b8d23998bc0ea628c3a1451830"
    sha256 cellar: :any_skip_relocation, big_sur:       "200defcfedecafcb13c9dfef7ff0b4c876d54649ccd579004aeea395087c2387"
    sha256 cellar: :any_skip_relocation, catalina:      "e9cec7034aa2b56efbefd00b40a591def959158c33c54ad75ce6e8dfe1f68271"
    sha256 cellar: :any_skip_relocation, mojave:        "9057ce4ca20abedd9a41bfae5f53b1b6f7411c1db9eea287655cba3e54624a22"
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
