class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.1.0.tar.gz"
  sha256 "7cd458c7c2d4aa1348a454669ff0bf251f816755b348df1f11841a023ecc4835"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c5a0d62bb6a6ce3f121c0efde1f1eb67bfbfb6510f1bc6a80983e74f2da65c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a19ea92b0d642622e8bc5226a591c9aa1777e6c3c29880822b6b504984d86cb"
    sha256 cellar: :any_skip_relocation, monterey:       "d956861a892fc8e59b68a18b4816168c6a32d5ad49fe37e70bbc6202fa9729d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f4510ade20986643aa4adf4ad7fd46e9e80f288a1d34266eadacd1cfc6b7050"
    sha256 cellar: :any_skip_relocation, catalina:       "313878ed127fa72f49293d194d8f28b87b7798a596fac27e82ae98e6efc89b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b083cf575c328878d7c2c4c989cffd6d7a744d5fc4bc616ef7fc6d9588bfdf8"
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
