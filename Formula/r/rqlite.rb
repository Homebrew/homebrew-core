class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v10.7.0.tar.gz"
  sha256 "baf9854cc6ff4492fe940f29d9474b842f49a9078cdc0b8e25f42182bd771ec5"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "06887d99846dfd73a3b31a03f28f073109c64e8d41eafddb63d9ac5f3bce5655"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eee22d52ab214dd9a283418575f5f03ad59b0cc2209cacaab83b9133e2ea9bed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "81e08714ac44bf989774e46a8ea3345d1bc8c9c3700b6ea6a6321305421ba265"
    sha256 cellar: :any,                 arm64_linux:       "2ef651b95499121d00ae1e4a35e9a4981fb7c1f089a97759967284dec440d953"
    sha256 cellar: :any,                 x86_64_linux:      "ddc0cc1d7657b061b8dabbb7e76b6f27052ea7ddf6ea4268f15a2c0d0dbdbadb"
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
