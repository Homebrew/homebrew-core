class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.17.2.tar.gz"
  sha256 "aa1ce0c70ed6f8d36e138b6fd3bed84a96f802c4704a9d62e08025634c34bf9f"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b35a27e26d475759081aeae28d7798f936821005522b704a87f61d8c4756fd78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "170539c1fad46768b5ebc275ab0c78bfb2c18d622d33c0f3084d1ef9dbdf0a8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aab05820f835a97d9d8d6ee1359f847345f4f0a8dcf1dc2938a9a0e4967509fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "857a48ac34ee6e856f87ff9cdd3de269b0a38cf893ec4c568240a143bb34eed2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e35be90f27fb2f172d614817d8f23eccc6f9af754d03d6fc93642fdef470ef9"
    sha256 cellar: :any,                 x86_64_linux:  "ae2d455d3a84f854b2d5278987e5ad2d520926b2662e840401900faa62d18f44"
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
