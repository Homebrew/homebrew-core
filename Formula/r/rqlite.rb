class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v9.4.5.tar.gz"
  sha256 "b60aa9dff1c45c9a06816aa37f6f81e05a572331fbe7ef4fb718ca370367f2b1"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a196949ae01312332ed6cd29290a1277716cbd49fbe79b3923188c535736192"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34b2f2338903a0a5365786e7e25dd5ef26e16bef8ec419cb8d22268f91df1946"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47f5cf1434642f096910e8c50d637182122c775b6789cf519f940e4c46be223c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e490b5432642ca557d3dbc8bb4088f6dfe2469d33014202f0cc24e3cb717ac78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c22059d42e5c92482ff6339148e43b2508ae92f78a65b1ce25effa981b9c81af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "293c55cd7d1d4887a37d63cb88bbbb0635dc0156eeb2e3fd4f3e90b5089a382e"
  end

  depends_on "go" => :build

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for go-sqlite3)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

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
