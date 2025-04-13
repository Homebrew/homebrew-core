class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.36.16.tar.gz"
  sha256 "295944ac1341369a6aee6fcbb27a12c33795eb7f0e26122f2240308bbc4f297e"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a91de85a2e414dbff07d3066b34b8e03ca7cbb463ef5f9d3ddb88fa1419cf7e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e8fecd87bb805b1a9470d975a810840935d099c72cd604befb1a988e51563c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10e3c5ba52eda51cb6a33529450a40589176883a3809f451330bf4c8b5da4006"
    sha256 cellar: :any_skip_relocation, sonoma:        "402601611d4c2d1696fd482056a8b8cf0eab48cb7e3c7c98f9fb2211d249ff5a"
    sha256 cellar: :any_skip_relocation, ventura:       "85b8048fc6cc00a16eab3fe61a39814afb8d3c620822ad5bdafc035589c5d098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0e846dde3a42c1c8f022a379f5a5f6cfc4f0309f0c525240bfef838956a65d1"
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
