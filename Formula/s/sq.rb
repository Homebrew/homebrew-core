class Sq < Formula
  desc "Data wrangler with jq-like query language"
  homepage "https://sq.io"
  url "https://github.com/neilotoole/sq/archive/refs/tags/v0.50.2.tar.gz"
  sha256 "ad39478132f1f056ec894cc36fb7d090eb1131aab8e42e108454bf46ea18f0ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2309132f02d23948bbd2824aca21ba1bbaa63429fbacd73c09a626ce6d997af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86ff35699927f1222138ca91bbc1ae39b94b45418009a9506f75fb4b18ceff0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b51980a0cd57d177afccafbab78cd0a3f33087d322000dad04ea2466203d5775"
    sha256 cellar: :any_skip_relocation, sonoma:        "37e4276bee75bc62079e695841b573fed2c8a43d78234503eb03e7cd3981329f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75568138a93cea1de32f9429e5362f02d7d432487fc8268daf201e534c26b373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a520c7a5e7850c33c79c6a60451843c93cf669578794fcbc74789f157a75e6b4"
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
