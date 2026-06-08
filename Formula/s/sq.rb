class Sq < Formula
  desc "Data wrangler with jq-like query language"
  homepage "https://sq.io"
  url "https://github.com/neilotoole/sq/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "6b0f2862977eb7093be30a0f10b00170d054e51c46a7fe3d53e5d0ac0b0f83ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcf0ffbac5252a20197148725ee0e8a80a975fc05b2a4ee7e6691c5f57adbd7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5fd0da4221bf6c87e0ea6576d3529907b851401982d884fbaf3765f4c52b2f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3634bf77df10e48f1eafd6c08c34a3223a5c52ba5fb701cbd3896e0d5985368c"
    sha256 cellar: :any_skip_relocation, sonoma:        "096aa6ebdf49a79f0024b34e85245e81ed37f275c29f33ee360c7e74daa30270"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab6b1c080e1a3056f45e8096602a244dc473d3b2667a9a5cbce847fd347e05bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "468263f38ff7410de1a277cde1a40cc689a8623d9af35194acf76ff554e19ad0"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite" => :test

  conflicts_with "sequoia-sq", "squirrel-lang", because: "both install `sq` binaries"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    pkg = "github.com/neilotoole/sq/cli/buildinfo"
    ldflags = %W[
      -s -w
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
