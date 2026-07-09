class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v10.2.7.tar.gz"
  sha256 "d1014f7e6c924fafda67226dd8df7d144fe71e5b5b7aa87e17eaa1e7f168d7b3"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71d94f5663e431315619631831ec78363ffe1c186f1c009a8a80aed9b77346a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "865a63c1e7f179468439ad438d0cc6b775d787ba783ebe70dea6b6bbb5a0fd75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bb5a33f5e53a9a82c2c1dce22492010188a649c8d707671da91a3d2b60050dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b7f5a5040085cd76432a692a221595eaeacede071a65e14fe21e1cc46da8f6a"
    sha256 cellar: :any,                 arm64_linux:   "bee5c5916b6d8dd92bfc5610f0ec308dbb407e6be064ddeb28c59059eb9012d5"
    sha256 cellar: :any,                 x86_64_linux:  "2b93e42aa0753bb051f0ecf4b41413698d7ace9cd5aa4a16db514b7f79475c15"
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
