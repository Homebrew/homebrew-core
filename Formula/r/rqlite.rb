class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.1.tar.gz"
  sha256 "61cc017b410cc73b1ec53b715f8387d315e63525cb5395b157bd4d4d06d4f96e"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54966b35fd231b206853709eb25615b3f6b93951dd01e694f2c243350ae606fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5402f5daf965a51713100d932546606ac3f3fbd23503ddbbc60c4ae7c3278aa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e84119b472eaa7f1cca6f85d5b2a09b6f6d2f0d427e693656e085901238d0931"
    sha256 cellar: :any_skip_relocation, sonoma:        "342453ece725c82ce3bea449fa3324a5c1c4b8e75076647e34f199523b9cffd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59893fb2aef000fae0d9dea39fbe78a45514d6abfdf9edc99e64c75fd104bc14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd1b8bfd8165c3cb642919931e51ffc07d9f078e320f099f93b1a0d7b628f045"
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
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output

    assert_match "Version v#{version}", shell_output("#{bin}/rqlite -v")
  end
end
