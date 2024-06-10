class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.25.0.tar.gz"
  sha256 "b1dd68bcacac8cae5e0c2b19534206a484421b69ba764971b8831b93bd4477f6"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "047f3000540cf65310a93039f824795d25147261ce33dffd65cfeba14a859597"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9888283f28c06758b5f809db80f5636fb4caa5cf42b023dedd5b4198ca402b56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e56793ac0272dd6ef1fdf1ad4f320aa24ad0136825ebecc1ec4f39a13e1d3ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d367ba938561ba3275d285b690efcb956713f15e771446f03f442ae3b22e54f"
    sha256 cellar: :any_skip_relocation, ventura:        "81b2667f4e90010dc7431f9599bcd75f43e4111a5d836c736103443591b11055"
    sha256 cellar: :any_skip_relocation, monterey:       "15641f306879c80ec5d7f3a64d15af64bb0838fb5f48188ecf4f7cfacdc0aa51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb44d397d519e5ca5d232fadd447a1f213dbbcc7c01dcf7dd40e0b1c0eac5a5b"
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
