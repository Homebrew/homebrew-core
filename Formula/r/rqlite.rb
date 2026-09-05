class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v10.3.1.tar.gz"
  sha256 "61b13407c64968861c126fd6190c857d6e163daf11ad252e8c7509f1ff70cd3a"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b99d4ae8ea276f11cd2b0f8946b7b262c48eb1f641ba22feb6df51be9ef06538"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80af983b84b61ad9502b5e6c73d9812dd0f3f29c9144a9cbea716a06c2ecb4f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e78cf7a03e6e98b8257eec023bed84f8a80a65c07f802e518e0bfcf559cd3ad3"
    sha256 cellar: :any,                 arm64_linux:   "2ce8143d5514b20bff8cf99499fb395a656c305b388e5d7e376ecaf6930a25ce"
    sha256 cellar: :any,                 x86_64_linux:  "02146b0270de971d278c3b079a921f067b7060b8b634bb9fc729765d7ca52932"
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
