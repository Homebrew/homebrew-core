class Sq < Formula
  desc "Data wrangler with jq-like query language"
  homepage "https://sq.io"
  url "https://github.com/neilotoole/sq/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "ab9f0595423269eacf43a531f1d101e296f100aabec95781dc8af6ab1c155739"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cfbd14bfd35e88adec5bbf7456046f0d84623686014673f7ab8640cefe2fa1a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3df4964678516d135b293441521b560a9c967204d7ac5d3bd7bf97f6c1cb6727"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f1cb3a1a2a7971f7a8ac7eb5c5c4d51a0359639f461cf49357cfc621e76bea5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "421da3798ec93c5c315fc1df3489a90d4cec2e1cb45e635c43e13891e0ffd062"
    sha256 cellar: :any,                 arm64_linux:       "bbcf1955ec20d64c0ae2bddec4ec74b35cc27f45e12127ebbf21421b4acda1f9"
    sha256 cellar: :any,                 x86_64_linux:      "d6f3ddd1ffe2770ff97ed8f40e93b9bdca602a485cdcc6e5430437a208ea67eb"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite" => :test

  conflicts_with "sequoia-sq", "squirrel-lang", because: "both install `sq` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    pkg = "github.com/neilotoole/sq/cli/buildinfo"
    ldflags = %W[
      -X #{pkg}.Version=v#{version}
      -X #{pkg}.Commit=RELEASE
      -X #{pkg}.Timestamp=#{time.iso8601}
    ]
    tags = %w[
      netgo sqlite_vtable sqlite_stat4 sqlite_fts5 sqlite_introspect
      sqlite_json sqlite_math_functions
    ]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"sq", shell_parameter_format: :cobra)
    (man1/"sq.1").write Utils.safe_popen_read(bin/"sq", "man")
  end

  test do
    test_sql = <<~SQL
      create table t(a text, b integer);
      insert into t values ('hello',1),('there',42);
    SQL
    pipe_output("sqlite3 test.db", test_sql, 0)
    out1 = shell_output("#{bin}/sq add --active --handle @tst test.db")
    assert_equal %w[@tst sqlite3 test.db], out1.strip.split(/\s+/)
    out2 = shell_output("#{bin}/sq '@tst.t | .b' 2>&1")
    assert_equal %w[b 1 42], out2.strip.split("\n")
  end
end
