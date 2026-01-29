class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.18.tar.gz"
  sha256 "34975f54c08ea3714d064d65197787edf834e5d06de0095772ed30e8bbec9d26"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "677248b71a6804f0c58ac8b96a79d57f5dae0ebba7415700e772515881f61a9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c25345b679b0be09908302f81534783e7f762aaf1d215d80f06e97a183587057"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8549f89081c357bb5da98f7b842a4efe324118cb58011ef239e71dae0094ef4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7aa344a9e4453d24fa2d8cf89c8687b95a9ac9be367ba2cbed3e72e8f153fe66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c900ef39fd654a9ba752131402331cbef78b3f7abc71bc57e832f1986e34ae86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d927bb041be0a0c3c50ff79f25071676d451f4b8878512996f89cf7540330cb"
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
