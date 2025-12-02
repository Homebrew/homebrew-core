class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.2.tar.gz"
  sha256 "5a48675999a442f3f3b323ddf638f01f366941bf2833f53c941edf6f16b51c7f"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fbb73f34e04494cf499af74ee1764bee8387645c5d01d4c8a5d1be2ac703d2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0b59161fab507bc935cb50cf5d7a113a3fab625ca4b7c9c3d82e13810eb25c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d828828796d623356273a64333fc6b7eb6d6c0d4290ebdf058dc96459c7ca23f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e72082f5eb8cd85f8fe8fd3c2490e8768a3978f22181e16b6f920cd2c94ad2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe8fc04ef46982640ffe1f6d9d25ea0261a14f268697530cccd8dec683ad354f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22aced588533be9398f47488242db406012b7a74d80f5e378e2307ac5224ecbe"
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
