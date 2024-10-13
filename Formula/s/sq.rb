class Sq < Formula
  desc "Data wrangler with jq-like query language"
  homepage "https://sq.io"
  url "https://github.com/neilotoole/sq/archive/refs/tags/v0.48.3.tar.gz"
  sha256 "46e75e2db83a6cbc98b07dbcfb23de03fc41b2b2cbc7de7aaee0425cef4fb9bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ac92a789727a715117040a35e3d4b3eac4c747f028d6e092899fbff5d095f9fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c783bcbcb9b86ae7849c10303b66fb66bfb14eddfdfede1c2f37491f46715f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac698e5af7d207bf310ec7b07fc4a4e92c4684ec846bd94c08dc2afef616d93b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3cebfcec2654133d4e5f264729e2926cc9aa8debbb799c790825ee5da4576c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3bb863ef4a276354a9fe8c76b54abfdfc9e55cbdea707dcd09a1f3b479b5ef1"
    sha256 cellar: :any_skip_relocation, ventura:        "8083d7ae858b43854461078d8c8e9a429472ffdaa6e54d4619a5a43767eee8ab"
    sha256 cellar: :any_skip_relocation, monterey:       "82f610ae37114fde1748bc38ec3a571294c1d0418c3ae07bad5cba120f07401f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ed9354f57bd345ce1360ce97230ef0b9362a4fee991ce34dd02ff94d8b0d9bb"
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
    system "go", "build", *std_go_args(ldflags:), "-tags", tags.join(" ")
    generate_completions_from_executable(bin/"sq", "completion")
    (man1/"sq.1").write Utils.safe_popen_read(bin/"sq", "man")
  end

  test do
    (testpath/"test.sql").write <<~EOS
      create table t(a text, b integer);
      insert into t values ('hello',1),('there',42);
    EOS
    system "sqlite3 test.db < test.sql"
    out1 = shell_output("#{bin}/sq add --active --handle @tst test.db")
    assert_equal %w[@tst sqlite3 test.db], out1.strip.split(/\s+/)
    out2 = shell_output("#{bin}/sq '@tst.t | .b' </dev/null 2>&1")
    assert_equal %w[b 1 42], out2.strip.split("\n")
  end
end
