class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v10.0.5.tar.gz"
  sha256 "f974b6681837acb920b897d7cb7b9f49a325279cf0d3ec43df22171064b2c250"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92deaacf7aacd3cd8c761b3e6496c8192e7e9f46238502b632554ba00f89a8e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "047f2fcbb14d2f92b83002ce5ab20477c093036021e1590b2760b62ad7dea17d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "923acd0f897109f7cedec078afa1c8ed2d9f8bbd3d67bc3706131bb0dfc7baca"
    sha256 cellar: :any_skip_relocation, sonoma:        "3642d48252ee24e05673c4acc7f0b06f5d95737b135fdee9b4e9e368fb2e3f46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80279951875da7c870962cb0090fb78b52f7f8892578db64baf643d7b1bf8089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57e4e2222037da9619045e6f2c130961c26c15ff9d13ffe1ac63a33bb03a8d1e"
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
