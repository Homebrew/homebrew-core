class Sq < Formula
  desc "Data wrangler with jq-like query language"
  homepage "https://sq.io"
  url "https://github.com/neilotoole/sq/archive/refs/tags/v0.48.5.tar.gz"
  sha256 "4ed9cef836e66174b6e01c8d410cd393aeae7f7069a428a7ab2adcd1e282cf68"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f881ab58b02e1df585ada412ca80396084379ac06466d7652f1b7dbbe9e62d95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "009e32cfa7b1bdfed2642c8b75e677ccd5811f3be6abcf5335d73a48920e738c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e352f3207dda7031075cf6e4031a7274ba697139aaae5d51c3fb31b57515268"
    sha256 cellar: :any_skip_relocation, sonoma:        "e33bcf953cb6bbf0e7f89f7a77d127842aecb0a51da794ce70bfebcb1cd75d0a"
    sha256 cellar: :any_skip_relocation, ventura:       "53b3b4140bc973c5165e5e14f0314691c24dc1f1e2be90e9f44b86d408426917"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28c043142fcd8006a7f83674be8c19ae724188da40c169597033525c23c1d74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17617b679286e017c0fc9fb0e487caf28d5692a1e86ae502c619611a0931b4eb"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite" => :test

  conflicts_with "squirrel", because: "both install `sq` binaries"

  def install
    pkg = "github.com/neilotoole/sq/cli/buildinfo"
    ldflags = %W[
      -s -w
      -X #{pkg}.Version=v#{version}
      -X #{pkg}.Commit=RELEASE
      -X #{pkg}.Timestamp=#{Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")}
    ]
    tags = %w[
      netgo sqlite_vtable sqlite_stat4 sqlite_fts5 sqlite_introspect
      sqlite_json sqlite_math_functions
    ]
    system "go", "build", *std_go_args(ldflags:, tags:)
    generate_completions_from_executable(bin/"sq", "completion")
    (man1/"sq.1").write Utils.safe_popen_read(bin/"sq", "man")
  end

  test do
    (testpath/"test.sql").write <<~SQL
      create table t(a text, b integer);
      insert into t values ('hello',1),('there',42);
    SQL
    system "sqlite3 test.db < test.sql"
    out1 = shell_output("#{bin}/sq add --active --handle @tst test.db")
    assert_equal %w[@tst sqlite3 test.db], out1.strip.split(/\s+/)
    out2 = shell_output("#{bin}/sq '@tst.t | .b' </dev/null 2>&1")
    assert_equal %w[b 1 42], out2.strip.split("\n")
  end
end
