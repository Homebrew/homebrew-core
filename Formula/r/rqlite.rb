class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v10.6.3.tar.gz"
  sha256 "3ea8bb2d6552f1884ba292c693b68995196e78b7da77af9dd604b370c7625ada"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "756fb287c6a6c69342e70c4a9e0ac77fe81f160b67fde0a8c8953657f349130a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "690bbcc780aa834adbcb5e49f0489c1281ee508232ac5e70fe4324bd8daaa78d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b0f78d18172b1b576cea964b935fa288bb201b07730f80a0ea6ece5189e186f"
    sha256 cellar: :any,                 arm64_linux:       "c5269e9a282a40b55d9e44487a8b4b22fb32eedeb9b0eb924f1862e53fc487cb"
    sha256 cellar: :any,                 x86_64_linux:      "340e21afe616fb3e06f4fab5e746ea7bd43d518c3d672034fc306bbb7b079bfb"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for go-sqlite3)
    if OS.linux? && Hardware::CPU.arch == :arm64
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
