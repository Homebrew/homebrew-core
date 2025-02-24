class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.12.3.tar.gz"
  sha256 "48e5ce1ec40f2426fda256c2bceebd3b7624aa5562ce8561ec389505d8db119b"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "608f70f1e5b5df294403e01eb555b7084bf7a51952b9e1dcf2417b65d055202b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "608f70f1e5b5df294403e01eb555b7084bf7a51952b9e1dcf2417b65d055202b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "608f70f1e5b5df294403e01eb555b7084bf7a51952b9e1dcf2417b65d055202b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f476a2ba32f75df7369957fe920b76792d2ff7c1bbfc2d445ae51a5e09f07c2"
    sha256 cellar: :any_skip_relocation, ventura:       "6f476a2ba32f75df7369957fe920b76792d2ff7c1bbfc2d445ae51a5e09f07c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94abb8ad9ac3d536533e595b8b7dfa86843c7bbfb0e0afca491f2aaf925d0825"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    system bin/"runme", "--version"
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
