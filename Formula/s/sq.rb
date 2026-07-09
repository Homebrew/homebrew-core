class Sq < Formula
  desc "Data wrangler with jq-like query language"
  homepage "https://sq.io"
  url "https://github.com/neilotoole/sq/archive/refs/tags/v0.54.1.tar.gz"
  sha256 "d56a1582f1a52ed6386718f14c3679ff32e7c3b9de644f55db4dd95220f58e27"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04325812f236a0441a04834f938dcd1d0e0c27244cd5d4e04546bafe0413053d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dffdc5ddab2bb2758e9b3dccd2f2062744ca33b57cbbc266f7f5c07a770d970a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "353f72632a007a63cc8073edd621cfdf76f9cee7e93980f92f3b7881ab1ee71c"
    sha256 cellar: :any_skip_relocation, sonoma:        "38aac9e723039df412a7fc15448583c85cb4fb1effb523839ef6664ef4c36c55"
    sha256 cellar: :any,                 arm64_linux:   "545c33e6284b6bdc395d1efd7eadc3a1128bfcef7b0ba47aef8aa35a31e3da69"
    sha256 cellar: :any,                 x86_64_linux:  "50058a73ff9af9a7abb2275cfb5ecbc8c438758ddff614db446b0836c8d7a62d"
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
