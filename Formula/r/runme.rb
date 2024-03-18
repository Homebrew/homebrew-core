class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "a8d0ae742d101481c182c5f5744b275720c800a6bf88fb6a3a83f359f868495f"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5fce6a74c1f089ebfa1b38c4c8e46a129dca29b97d9289706eef66827e574cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61d995c0dfcc5517ec915722a669644afbb2f1d6ec878f85e4956a0231348461"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fb34d4f5372120ca4e20c43394c9aabcdc9be57d40aca9fe8e4c0967bd24640"
    sha256 cellar: :any_skip_relocation, sonoma:         "f262179d0d4a79c04b0fbf660966e7b631b3e037d315270f977ef25c037cdbc0"
    sha256 cellar: :any_skip_relocation, ventura:        "66812db24765bd498d3ec0d9abce9d8daf489d099e1f73a93f8c3355c8e02b64"
    sha256 cellar: :any_skip_relocation, monterey:       "933039782ca1c73707b8a4e164cf36359d96b8e358d8641fcd9eb5858128c369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a29142937de3fdba6d96e406907178a8b5f0b4f5722c09e5ed9ec64fa900aef2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/internal/version.Commit=#{tap.user}
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
    assert_match "Hello World", shell_output("#{bin}/runme run foobar")
    assert_match "foobar", shell_output("#{bin}/runme list")
  end
end
