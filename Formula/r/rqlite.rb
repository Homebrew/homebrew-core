class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v10.2.4.tar.gz"
  sha256 "6614016449ac31c1ab4066d25961d333c4a397647b50ec193e6ddd5cbe1e1c94"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc9f366f9918b3c9a349724a119f6ef4276a5683335679b8a8bdf2344f28aab7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9db85a40c7a9349329e9af1a11abacad56707ac2058038fd371f0064ac17ba85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e884f0c5f26492a149156c9b5405a401582adc04edcbf3b634b64c24a5b61e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1c07d6471aa5241f938b0de4282d8abf009ec9bf7782c139bc4d95a9f3ff81c"
    sha256 cellar: :any,                 arm64_linux:   "01b4f8976e747a6a36068e5c9447f13b63063f67af4a07ea3e3b548745b88193"
    sha256 cellar: :any,                 x86_64_linux:  "044c74f96afdeb4a9dd6c620097f4662e73703beec654c5fd29c6ef5d63324ff"
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
