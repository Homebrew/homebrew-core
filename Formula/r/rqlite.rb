class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v10.7.4.tar.gz"
  sha256 "41e8653d468063fb061f7d57bd9ef77446d08e7a541aee22dfa2046f746dd7cc"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "72bd451964ff590aba6e6c888d7b327e446b93697770d26a1a2cd5fd9da9d5b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d51b649052bee901bdff56a24da6b75ff24c63db697b5680ef385569badefa7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0cd3b6d037f81eba653bfd5830a9ed56e280777b1617c60d5078a1eac5167f3e"
    sha256 cellar: :any,                 arm64_linux:       "86fcb2fca87a05774720834bd694ef84a566cc19b87ec03f79b3e4239334934d"
    sha256 cellar: :any,                 x86_64_linux:      "5de825aa5553f6d1f06f8caf97a394209dd895f7d741ddaa6c80638f4c3d7757"
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
