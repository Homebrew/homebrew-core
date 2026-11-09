class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.17.7.tar.gz"
  sha256 "f38eb84080e12a202d18022c81acb979c6a21af258deecbd212702f8e423ec62"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "565d6b8b6d3143a2b8bb2123b3021c261bd98074d22287eb978359f749fd491f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d05b7392f832747b93f3c331d1733b70ca22152c38a223c8cc67ace02990da2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aac8d37a9778a9fab7fe106a3a266c0b232cf3cba1700bca62351f4670f6619f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6fecfd69bf350d85c1fc2a8c6f55eba520e006faa289567d99929977e719571c"
    sha256 cellar: :any,                 x86_64_linux:      "1f7bc66b7e961d73bc7d3f045b986c343e2b16569067c7829ab812f541cdda94"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/runmedev/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/runmedev/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/runmedev/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"runme", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/runme --version")
    markdown = (testpath/"README.md")
    markdown.write <<~MARKDOWN
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    MARKDOWN
    assert_match "Hello World", shell_output("#{bin}/runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}/runme list --git-ignore=false")
  end
end
