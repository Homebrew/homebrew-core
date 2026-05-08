class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v10.0.3.tar.gz"
  sha256 "93b221b28d66a084918193abecec6f8fc86b758a57eb45e8fdfeedcf96a033a0"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f9ddce32a70f93d3fb37b2e2cae1b623d5afe2b1bb43f9f785d8fbe9fe0206f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d94041384f5b5ddc1694f92b4aa84bd36867ab35c491e2bdcc0a27e11996f31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "597861ce60a9b0a502f58a7d1ee282072875b0fdef64a4c0d2749cbb883d7c6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdedc01343715a901d0043a34adc91444b36cd401f2c7d2ece59b4bd79667621"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3acbb454b1441ae8c903c53f4c4aae57d864a546156b31d7250f63baee062b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "969b5ec9451018d9eb5f5befd71e48c94cdfbbd9372ad0ee7d2334b95ee4fa1a"
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
