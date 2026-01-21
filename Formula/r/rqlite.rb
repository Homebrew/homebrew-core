class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.15.tar.gz"
  sha256 "46a329f5ed4f310ea0f1d99a76b9f4624719d0cf7dddde2b99ef580f66988f9a"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "647f667753ab653184c3562f2a9bef0941426103456e5ff957f2685bdea0c45a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7838dfe2dc1b02f2d964bbd70d6307acbce08f176a5afd071314655b621a9ae0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba2f746ee29b8698e578bccfbcead7cc41e7522aac000b007d1ce4137fa4f694"
    sha256 cellar: :any_skip_relocation, sonoma:        "d509d0637b18ec19d04a6ef22b20911f3d6dd46f5d89c862a4e22dee3cd6c0dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebc841fee1b29c2a22d3ed0d78eae0fbad9f501a778b7635bda1a096bf319db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b663a1b3e2bfe55c283d288839725aee6fe3833336e0e27d5f9f2323084d7009"
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
