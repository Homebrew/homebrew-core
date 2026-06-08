class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v10.2.0.tar.gz"
  sha256 "46cd26b490cfa5fe4a2a06f3cb296d5c05707c5b44a06f788633cb4938691361"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7f4ba515517caedf96adbd2e9ca66a4452c1da8acedab4d91b968974afe5851"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50a1aacac341f51d164b49a91a6ffb9fb047403a4cec03d31a464dad4f96b573"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4f96f5abf8c2cdd1e2b53cad82b48659e19901709d0e3213631da105a4a25e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "76f63be3be0b9a89cb023834bae027c9aae5f8519c8af439cc330a505322ae97"
    sha256 cellar: :any,                 arm64_linux:   "16c816aeb8aaef5128b5b561f6bf3e210be8f03606511573e63864a9fde6ab59"
    sha256 cellar: :any,                 x86_64_linux:  "4f3bf01b2c348ff3ee7b99f789d55edc3c9b675b52f10606bbc6a432a6f52081"
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
