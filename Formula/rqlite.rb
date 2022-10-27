class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.10.0.tar.gz"
  sha256 "3ccb9deb7353b212c38f3e3325cbc1c896fd827f7355e9d83b3e1e445efda89a"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87fd2b890057b9453182018878fed0e87bebe2e407218c43738c2fd8496b2823"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60578816f5fec897f1a0816c693a5cfce129011ee6ec979806893066f2867eb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "751a89fca2ff043a49a98b59c02a204b68bd34e40e3dbab64f5676285d521d9c"
    sha256 cellar: :any_skip_relocation, monterey:       "0aa8484950b30814b27a45595717005f4c9e0610692195ffff71959c6400fdab"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f436eb9cbbd4a14135b7f3809c3aad199c6f1e4681a10e02ff6e326525c8ee5"
    sha256 cellar: :any_skip_relocation, catalina:       "4604828192bf2ca6592541cd793de9002252f7ecb4685ba11fda4aece9f1926e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8165bceee7af87e38e081323bebb9fc1876add4e051e9d273ec8a842ef730c92"
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
