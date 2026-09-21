class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v10.3.5.tar.gz"
  sha256 "0bf2feb0be928b2a1ad201ba8d6bb842eb99e2c4e259c8aedb811a372a71ecdf"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "215b1b5d7e2f1519c842c1625855cecd9c5511730afdf995dc3ef471d6f66934"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4f058fadc4bef96650dc85d27704819beefbe07a2e4ff777bbff33eac4f8666a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6422f588955cc0a917714b4f04481aae018f3f842214f2dbf45075f4d5c3fc14"
    sha256 cellar: :any,                 arm64_linux:       "f98d0352e56cfc050ff1f99ef31ff44a45a34a477d783cf59fed91efbd769a3e"
    sha256 cellar: :any,                 x86_64_linux:      "5a105f47b6eaf33a9d329d293d8efdae029a75b33a8732f7adb74fa181a985bd"
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
