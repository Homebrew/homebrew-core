class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v10.7.3.tar.gz"
  sha256 "e81eac0888d03223e653d799cb57eef902135ffbc8d3fc1519f795b63dea8133"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "676111371fe9a0e0bb6c0a326f41141193d6149da858787bcc6f32b83f604480"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "865b1a17a8c161c22290c4a00598e54fd91d56d64338391995cb60d627b6c7ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "41b265cf3f2bcb99b968fe5e5be20b5952e2bb5b7917af3ee56e046fe28cc915"
    sha256 cellar: :any,                 arm64_linux:       "1cc648b38597d4b57758a6da480d7da0bd730c277484c012d41bdda058629bef"
    sha256 cellar: :any,                 x86_64_linux:      "c640abeb694ab4be08abe7bd3cba23d92aca20d748d0715c4af822b6d71ba8e7"
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
