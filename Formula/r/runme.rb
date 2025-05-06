class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.13.2.tar.gz"
  sha256 "6aa04d41735d1d3f5cef9f96380ec61c31ff8ec04f82a875958fb3db7d069513"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c6f5e81e1355c8867293f14eec182f4779147f732631a1c01243ba5074ab94d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c6f5e81e1355c8867293f14eec182f4779147f732631a1c01243ba5074ab94d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c6f5e81e1355c8867293f14eec182f4779147f732631a1c01243ba5074ab94d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6a2c2deca518146e7067704a362f026b216f2fe78ecea4839f78501e31b8a99"
    sha256 cellar: :any_skip_relocation, ventura:       "e6a2c2deca518146e7067704a362f026b216f2fe78ecea4839f78501e31b8a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d231e79a8f53efd35d0dffe40eaf8b771837b1ce9f11db7a1c8e22f17f595f7"
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
    generate_completions_from_executable(bin/"runme", "completion")
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
