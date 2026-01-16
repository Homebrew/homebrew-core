class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.14.tar.gz"
  sha256 "e0ff8df4bc9db7604513de19b6f15e477f9e4a1627b298d90c165152658ff963"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b88ff46b78a784eb44e0d055cc7e97c55be267f44d8b7bc1ccd9c7cb6fcf0d18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cae5e8c7e2bd924a1ba3f33751bde7657b4946f0596c290c815a2b4d56d5ca76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e097dfe16f0296e069fb9aabf85b05639e0f2776cdffc7da6d0dd249549867e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4b40d4f450aabcdaf9cc8c8b14088fe79abeeca30d47a044626f7543d15cf91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e6ea80342aae20825d2bd6d18140d7caf14df521f3a279902eac7fdf2139e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "197e3c148e221222f3b94a570bd3d5eed2da3502eabfee850d5fd853a6a48fb0"
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
