class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.17.6.tar.gz"
  sha256 "91d80a79ef0523dfdd42653fc4b6d0f4c708913afc2134717a04e049291f4651"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c2c492a80d5188e6eb1b8dfe6abf06df73335acd89802884c5d7ee39f94af62"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "12ae6d9420826627c9cf6010e30adc1c1d7d0f2e14f6c3e45f9976940dc94392"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e6502a644429cd2b2f14f37aa24a7fb448f1af79dc1b576da3423348c126c518"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1ef6f271d2321528301fdd6f6c0220d81c03846f29f39f53ae633c894b94603f"
    sha256 cellar: :any,                 x86_64_linux:      "0c7087233c172ffb9fafe4f1af53580ae1160e828e4e9363126b96d1c214a0a1"
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
