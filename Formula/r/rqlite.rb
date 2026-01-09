class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.12.tar.gz"
  sha256 "add192e46652188eaeb1e530d1018cb2052e30649bcc86e36744d04489569641"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2231beff6435f3362c0a623f587e153c650696365fa412fcd797b6b4dfd1c68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "353cb54a92e99ef1ba56bd26655570e2f6111fe5fe210afd08fe632c5f3dd9ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "554ad9cc75a944ed953c9b2d3f29b26f99f949934c806fc505236d88c4decb9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "07e43270307e3ba4d78f96e49dc7507da4f308ce08d4dd79112935cabc752943"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d89091fdc4cc046cb163af28ddc93a2fc79b49763deb0d01a90158950a034f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c18e4798ce0d8a26ca6f129b5e5a079925088a213c1e165339946d0058019412"
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
