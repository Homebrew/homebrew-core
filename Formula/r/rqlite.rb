class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v10.7.5.tar.gz"
  sha256 "80ea01f799854f121b647f15a126f8a41a1188e27f3a5eb7ac4ae31270bc9e1d"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    manifest_sha256 "c77228b6d5a15dbd48f49d1100ca569766b0b5e50756598a4140cfef023a21f4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a2701c3536f9632816ddae99abbe7239f9530148a71361458e53b9211868f88"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d467fad2d2ed5e6ad1b8f52aec8bb49ea3e644150c30b2ce13287e23e98881ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a4901e9ff94f8eb3772ef3d6396df4e388e33724bd51d58152204ffe2623206e"
    sha256 cellar: :any,                 arm64_linux:       "e578e1a61247d27cc771e193fd12b7a49cc6c971351d9787132dfdf63721db30"
    sha256 cellar: :any,                 x86_64_linux:      "c9ddc404e70ad41b32fdd33511e99a4ff3bf38a276811a0f7ba199e140aa2ccf"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for go-sqlite3)
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    version_ldflag_prefix = "-X github.com/rqlite/rqlite/v#{version.major}"
    ldflags = %W[
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
