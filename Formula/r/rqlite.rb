class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v9.4.1.tar.gz"
  sha256 "a1801d0709b46187573b655a3182021f92ceaae4a1c0a14b3f0c13aa7b642312"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7634a091de60128276353713cb748df301d5374be3bd81fcee89b8077fd7e975"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d2a7bdbe16bb7e7967576a46d2cc0ffa68f89a2fb9da9f320a6adc60d132df1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "839ec383e849ee43325c87088779cc8b2f173fe95c983f7fa306c3ff45988135"
    sha256 cellar: :any_skip_relocation, sonoma:        "81b52055cf40b458b8e84e611a4d45d8fc8d90eb110ba9038573f5cebc412656"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53a095de7125b1b0a2536afed0f487462faeaf6eea19051b820b7a362d7dbeaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3b7054962df4e08ef741001fd5836d9f8711add61d467e373841d020536b3d7"
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
