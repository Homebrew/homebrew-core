class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "b79f6b0102761c3da66472f6bc3bd8c9dec13953416be82ecb515820dc7ef0eb"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02247994370a6cf58857b56004db5dfe327d536674145f11179d8435082cd9b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "234346ad9f21aa8a868ec84e862b6f68df6a6371409df27030cace00673d122a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd388a9d7048e3b96517e350180d311ff765f36df1a6e2ec92ec4bffefda630c"
    sha256 cellar: :any_skip_relocation, ventura:        "51172d00ba6dee868faa78bc9278b0e67d13661070502a69977bdb740a5ddca1"
    sha256 cellar: :any_skip_relocation, monterey:       "9aa4651ea252747f700a3d222c36f0f8d54d3ac490c66bda0648db03ee9875a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8344fa028064305fc17b4e424119a8c1a12deb2ab7be2347153cdcfd8e92394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "743b621cc2748148704100c61f887f5f23771729cd946ca14e06b25266c0d18f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    system "#{bin}/runme", "--version"
    markdown = (testpath/"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}/runme run foobar")
    assert_match "foobar", shell_output("#{bin}/runme list")
  end
end
