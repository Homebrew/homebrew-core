class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.2.7.tar.gz"
  sha256 "5c08b024008916e575a4b37bb5b39b3d7e1d85c1152c031402f340e71197d8b7"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5e8a04f440f299e1a4619fdd4fee4e789a124ad65ec218dd20ca433f639ddbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a3520048d04da4a7c48a0138bc3cb4f42e0e0c7ff437f82a02448e11527035d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6539f7685cfb9e72203172f16a962a0488b2706998f8ff272e421472734fcf5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "55d5650de6dfc15f75999fd1e2c38101056c4b89d768f58a8077d6cbdb3565c9"
    sha256 cellar: :any_skip_relocation, ventura:        "be9dcc30f4e3570e50fff960fb094b3e858c33b137b2010b94daa8c2e1046251"
    sha256 cellar: :any_skip_relocation, monterey:       "1466264ebc124cf5a2ea4227b27f162a95186a4654616f525495e2b54c33d01d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d299d07581a8079815fe3c4a0af43c836847688484e59771f161bd91e60df9e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags:)
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
    assert_match "Hello World", shell_output("#{bin}/runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}/runme list --git-ignore=false")
  end
end
