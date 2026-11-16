class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v10.7.2.tar.gz"
  sha256 "b81679960cdee788e4bb859cd76bf5a7a6007dd15d71ed85bd3c2598f898af9f"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "439bf4a0cb158276132dad71c7db1a0ab509a478d016b7f0a8ba105f7e0027a6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "af98065dace4990da8de6563caebd3522633ae8ac5209209381d94772db39791"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29410d13c0caa8b6f6d6496e7561f245297ef9d0aa6b3060d128d0d92629a058"
    sha256 cellar: :any,                 arm64_linux:       "22734395cd39a42ba8cbb6d4e71713606b808c15342b0cea800b483fb43db8aa"
    sha256 cellar: :any,                 x86_64_linux:      "de2a8f661d1dd4320527eeaba45cd45741b24519af37772808d1e49e1ccf72ce"
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
