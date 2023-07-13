class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme.git",
      tag:      "v1.4.1",
      revision: "364109390e5cde1ee94631a4566b13625ab27eb5"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b1ddda30cc45ad8c3eee1c85346e5dd3d24785fc139e6132de8213ff64e99f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96371c7c1833ff86b9e2ce54b71956297fb852f8bf0f75001b4588313f9c4fa9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2171f9bfb8411b78202cf574639c19309f03ba3ac26e8b1c6280f0a37e7e93f2"
    sha256 cellar: :any_skip_relocation, ventura:        "f0904348ffeeb3ac63d3f1c0ebe7608f4c01702c1b80d630b976e8dfd6eafb94"
    sha256 cellar: :any_skip_relocation, monterey:       "4e0a6a64df0d2950304149a8167538012ba055ad794ba6a63a828f1d7e2d1e39"
    sha256 cellar: :any_skip_relocation, big_sur:        "942f9c5b11b16071c4e1a9c1d1201279cf9244df59d67045688630ad54987e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07bc93a288752cda354b1741a46b6d60d38698c0857aff657c31dd42ab7a1a47"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/internal/version.Commit=#{Utils.git_head}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags: ldflags), "./main.go"
    generate_completions_from_executable(bin/"runme", "completion", shells: [:bash, :zsh, :fish])
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
