class Sq < Formula
  desc "Data wrangler with jq-like query language"
  homepage "https://sq.io"
  url "https://github.com/neilotoole/sq/archive/refs/tags/v0.48.5.tar.gz"
  sha256 "4ed9cef836e66174b6e01c8d410cd393aeae7f7069a428a7ab2adcd1e282cf68"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e7e26f4d83f7829d91c329688d051d834e8a8af95b2c020d67793a5eb87e236"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f7d17fcc389a770e377f4c1decb25b033b40ed0f3054982f4fcb73ffaa32f32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ab356e5d43c53e4afbd823d3ed7205b148273fc79ed08e36428bc8b42a50de9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2d2280b04a8a8b9cdd5ed35dd5686301c9708e580001948012b68ca5377cba7"
    sha256 cellar: :any_skip_relocation, sonoma:        "66320e44d65e85d579904c7f4dd8823a8fe9ec18a59e7e24b38fae78565656ad"
    sha256 cellar: :any_skip_relocation, ventura:       "5b7ab78293193479047eafccfce81247ea02d73905bff3ee35a637ac76f241c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e5e69f47d93f1c7eabd2d38fae687102066278536e9f12dc130e437a7158294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "436b94f41c3c115501602d3a4bacae43e6b0697dba66e4801527ad5d0b867b42"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite" => :test

  conflicts_with "squirrel-lang", because: "both install `sq` binaries"

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
