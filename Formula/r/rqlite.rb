class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v10.8.0.tar.gz"
  sha256 "d814e067d68178e962a4722ad7d4afdcaca7008fc37755de2bbab265568c238e"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    manifest_sha256 "9271c9ef57bb0935c988d54818dfd752536495fdeef8536ee6dc4774ef82246a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2c316f1a37e754265079ef0a3780af9a5fc1e68109b587f7c64f2db69740bb83"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0786029cb4b95a58f85c1506fe626ae17443b4b8013ac06ce4d7da8636f3da7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5f7bfa35533b67c4a4199a048347309559d64c6603a7d25cb9d2a26d4215022"
    sha256 cellar: :any,                 arm64_linux:       "38b9b884d1d29d05cdf2a89f3f1ca7fabec6ac4dd0bddb2202f99cc7d6596076"
    sha256 cellar: :any,                 x86_64_linux:      "32d491f2afaeb71d154b3fd1f63367dbe2fd7542747c44fafbce60d45fefaf9a"
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
