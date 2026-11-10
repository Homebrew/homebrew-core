class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v10.7.0.tar.gz"
  sha256 "baf9854cc6ff4492fe940f29d9474b842f49a9078cdc0b8e25f42182bd771ec5"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "67d96ee1efb5efeaf8cb15c5f143d999eb851e9a5a5e2515eee26f722d7bcc93"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1327368d5893540b989f2b22fa8b3e729a20e7bd3e71e9d0f30a8f214f46062"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e947f66738924907013bd970a58d56d7886df3375121b2ec74aa81b00a947c5"
    sha256 cellar: :any,                 arm64_linux:       "85740d556bac8f34c4432a0abcb822490b2d7f1660c9001c8dcc487b9abe1f3a"
    sha256 cellar: :any,                 x86_64_linux:      "cb761feed004e2b50de92cf2953d5f4a874965dbc3ae51f7cc2621ae030f1a5c"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for go-sqlite3)
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    version_ldflag_prefix = "-X github.com/rqlite/rqlite/v#{version.major}"
    ldflags = %W[
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
    test_sql = <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL

    spawn bin/"rqlited", "-http-addr", "localhost:#{port}",
                         "-raft-addr", "localhost:#{free_port}",
                         testpath
    sleep 5
    assert_match "foo", pipe_output("#{bin}/rqlite -p #{port}", test_sql, 0)
    assert_match "Statements/sec", shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Version v#{version}", shell_output("#{bin}/rqlite -v")
  end
end
