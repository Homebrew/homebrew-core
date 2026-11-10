class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v10.7.1.tar.gz"
  sha256 "36e21568c1b2f34b7749a2fbb862e63f0fb9f084116d77316f2dbba72c3e227b"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "178d153221c4c639c838f9f7ad2ca1df7a0578d1803d98185b5d47af257496c1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3854f1a1ee1ed0a1a8518a393718f8d8e6c6a480c55c16817b9d6bf30b28bd20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b67d2c83ede326d8aab3c8471c70fef603b6f2d13739f5e7ac3d5f25db09b249"
    sha256 cellar: :any,                 arm64_linux:       "5551220ba3d40cbdb906e7feefdf448f343199dc1baff9de1782afd7d44085b6"
    sha256 cellar: :any,                 x86_64_linux:      "cea7e18983fcc5935ad8e3c21f8401f2a824aabd2bcbc18e059570bd7e4ff943"
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
