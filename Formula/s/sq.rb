class Sq < Formula
  desc "Data wrangler with jq-like query language"
  homepage "https://sq.io"
  url "https://github.com/neilotoole/sq/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "fc0350854f40ef54a820744f622aac25a005c918f42e1e6181e13aff620c847a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80cf6e81610c2e2825bfb5665ef16be4d208ff35e6c07ed02b825fcc713f3f1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be2a04d3dda2504b1e9e6b292a03c182fae7d9002083bb61ac7a26de90064a8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a37a5e434dd50a0905af5dac8741ad51ea51e559e8dd3a6c931e3bea8939d577"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9ce6103f7e3bccdc6a1c3044479dcd8eacaa236dbb9b64a29cb5dd61c6770df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e948b94a569bb41b06437f71f8c60b5e6a64c4878b3cb9e2503cdc9e89f402fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39cd117716e9534e2df57680ed3dba3bd1d6ff63e6db76bdd04c268c697e3f30"
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
