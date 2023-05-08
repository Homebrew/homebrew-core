class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/v7.16.0.tar.gz"
  sha256 "c7ba946b707c958ac8fde544ffa9a78407e993dddfbc058af50efa45385a9f20"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78ccf05f92dd8e43ca6799cf27dd449a14e1752ebcefe66bd4629568e69437d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "635a24ecb640bac91e20043feaba5f8456c957f001af599bc453364bd96b956d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d74d69d1445d32b024d92deda0faff7c7dbfb5ff559e2ce29f7c83d920fc667d"
    sha256 cellar: :any_skip_relocation, ventura:        "11402e6bd4ffdb8094992b84be7326dbcd687a2b591fe2d7fdca4b50ac0c83d8"
    sha256 cellar: :any_skip_relocation, monterey:       "fa84f96d8894b4f5a0fdcaf69270081d353892e893b2b1c5e77bb823f54b9365"
    sha256 cellar: :any_skip_relocation, big_sur:        "a37e495db37e5f5e3a9c6f4ed95ccc6549931933ec8f0bf22712aa901f8af37d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7084475dfcc13bcd80e2bd3ebf62f2694ae08ad01b8cf9703635ca4fe00cda82"
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
