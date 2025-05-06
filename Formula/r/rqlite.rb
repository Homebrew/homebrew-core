class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.37.0.tar.gz"
  sha256 "ffac7c381fc3b79ee596f8058e1aaba74f3e62e79323f168ede7ced53c98c28f"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73272258e33f2da35f69bcfe51224b63cf53f5cb7f019ec553f0a1aefb934174"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9007130df83cfd51961e59b5b3eadc50ede8fb22e971cad59e2e0813f92ece0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74d5a726c322047a677787aa6fac3bb1623e5df0b96bd99f3e165c573e9c1e67"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee4992693bc62423763088b402cc9234991591d013c93ebdf0013acf93bdd01a"
    sha256 cellar: :any_skip_relocation, ventura:       "48baed0fb6a27d9e62e33715f98c0fef7fa0a0547a49e190dc336026dde4ef26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0a73628ddb231b40cd62f28aea6f66dd8b5cabdbbd94fe95beb5f7bf8ea7855"
  end

  depends_on "go" => :build

  def install
    version_ldflag_prefix = "-X github.com/rqlite/rqlite/v#{version.major}"
    ldflags = %W[
      -s -w
      #{version_ldflag_prefix}/cmd.Commit=unknown
      #{version_ldflag_prefix}/cmd.Branch=master
      #{version_ldflag_prefix}/cmd.Buildtime=#{time.iso8601}
      #{version_ldflag_prefix}/cmd.Version=v#{version}
    ]
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags:), "-o", bin/cmd, "./cmd/#{cmd}"
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

    (testpath/"test.sql").write <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output

    assert_match "Version v#{version}", shell_output("#{bin}/rqlite -v")
  end
end
