class Sq < Formula
  desc "Data wrangler with jq-like query language"
  homepage "https://sq.io"
  url "https://github.com/neilotoole/sq/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "36e20553b05aa10069ea3a422bbd98df936f5ca505eae9d61b98ff7ee0b7a279"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcffc70c1e0315e1999e72b9258ae407f14114d42c889a8296ceaa939d713790"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4057cfa30bcb15b76b8c6a47e43bcc292dc9bfd3cbf06b744b38d64ebad75652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f89d005539fde2deaf27288be32d4219ea0e18636e4a82a8346915c6da16b14"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c2b647d37e86459440eda9fcc06eb1cd859d0f51e73809a42c4eb568a20f050"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dddf64c8ad704a8d410c384489d8e5b24940e095c6f8db6b3693fdf41150bca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18535bbeebdd4f659dd4e9074f351f046fe105f4849a0b03b3650337bb3acfd8"
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
