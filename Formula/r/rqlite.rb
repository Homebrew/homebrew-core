class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.18.tar.gz"
  sha256 "34975f54c08ea3714d064d65197787edf834e5d06de0095772ed30e8bbec9d26"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a8684e64db4b2289b49d0b1862cbccccd080ff45091f7ceb8a46f74deda5405"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87584aabedd4cd10cf24b6cf016eb3567d350aff733202515fadbaf0cbd51516"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04ddfef61552e81b05b41a418119461382fc6b15436ed231dc8453a6eda10753"
    sha256 cellar: :any_skip_relocation, sonoma:        "42433d80f035ffdeda8051a593a7c3849435da013bca16ada7dc60f32fb8df83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0971c11d1e6764c4f234a9fc93b59bffb1df76fc6e0aad9a5137b6b2b32fcaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "670b1c2583c2348e3b21b4f8472da6d27689f540a14d46568602a0e40423a0da"
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
