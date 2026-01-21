class Sq < Formula
  desc "Data wrangler with jq-like query language"
  homepage "https://sq.io"
  url "https://github.com/neilotoole/sq/archive/refs/tags/v0.48.11.tar.gz"
  sha256 "dab57e0f3e6f98fcea390be721e1cdc2d26a894fdc89a2821ada04fa14df3eb5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec5dd0eaed31c823b287c0afe2de3d4371b1bc5c18ba0607083e1bea9bb26bc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "817ae813b2c9f539299dd8494f81a351e0b515a7c14e4047fdbd001750e9029b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46bbf709f3e7e90cffa9fee0ee84aac695950f7772d9e26dc792a4f61349b2ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "209f6bcff6655a4645c3ffb7bf70c5e8cb92dbbb09a1b47dc44518fe8b9a7472"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f59bb2a7afef8e4162fe5a58531a3fe59ffa9db108013b59e6596fb8ed5d2aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fe001ac84f469d727b3dff980775e40901c71884daa80ecb555549cae5d60a6"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite" => :test

  conflicts_with "squirrel-lang", because: "both install `sq` binaries"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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

    generate_completions_from_executable(bin/"sq", shell_parameter_format: :cobra)
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
