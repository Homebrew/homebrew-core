class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.16.10.tar.gz"
  sha256 "0c10eedcab51bba78c230feb3f567acd53d2b45e0ef444e666b10d751e2ea88f"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98e25af55ec344cb364176e886302232a53d2da8ea8f1eb8980e85a2fed4796a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dbfbe46d9e6d169823c68708752b53c7e85210a2da01ed7d88c5af64e4bb18d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "751bf9db24733bfcdc22cdd6fb9af537ae63556040a97715db9b24a94bc12f8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "254e56c65009edb884952f0ca280deb350d119d74dd46004f44cd8490e51748e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ba57a10b6d33cd202b662b974669d30a9946e61b2e2072d780484cfb1fa0749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e6890841537891fe37824049a6d13d2a3ebdb3d4ad4c59ade1a4613c89ffa80"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
