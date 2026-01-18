class Sq < Formula
  desc "Data wrangler with jq-like query language"
  homepage "https://sq.io"
  url "https://github.com/neilotoole/sq/archive/refs/tags/v0.48.10.tar.gz"
  sha256 "df2c8082727f95787416375663578a0be31041bcbfca71af606a84935bf2b94d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11971a3016995526f742ba87cc83dfeb63bf38c7079a0d54fde30ee5cbd3d8f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1100e0de0e666e5beeb3a8fc1b7a32e2baa1130345baa5fc87ecdccc9601c14d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ad02e466eee21dbb57ed160f71faf735e3399efc662ee5a017b53bb90acdfe6"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaaebac9842033601be08fed1a13d5c081a39d3a0425beb0f475a177005ba0cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f021ce8e84ffa53c3ebf8ee5e2db15fcff087dcb831c9af14b49340fdb6dbb6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09e98e47658696d2c3f8ff5bd3456bbcac8f3351f73b273fe65d7e21e3d0ffac"
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
