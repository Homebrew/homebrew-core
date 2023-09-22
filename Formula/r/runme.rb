class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "a2f03ef4edc0ef8b7b205706a47b0291afd6c67eccddc7d233e00c0529d8ecd2"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae62fdcbe452323d53a5b4435c225e620992053fd5a1f2a1b8cd32ee03baa605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "351d811f99b3053a844e55d4083b40574e92ab805aa8bcdda3cf1c6c78613ea8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0cc46883ff5bb9499ded9b2d12274c304c569c8dd28644367c702f3738ef7b8"
    sha256 cellar: :any_skip_relocation, ventura:        "ecc480006be41f335b8e358834a676f2ac3b1b4343482d3d1aaf057474c3dcf5"
    sha256 cellar: :any_skip_relocation, monterey:       "cd6a82441345c0c56caba450e74ba143c3853d2f4445913d6179daff53047fa9"
    sha256 cellar: :any_skip_relocation, big_sur:        "70b10e2d89b621962aa83d3e2358c720c4a87af46968b1394ffd6f6b210bfaf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba5a770eb39b83d6a6444c2d14a04a2c9d7b4db38fd0e0fed455906fce189b54"
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
