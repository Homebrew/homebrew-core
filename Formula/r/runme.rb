class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "a8d0ae742d101481c182c5f5744b275720c800a6bf88fb6a3a83f359f868495f"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "551020c1ebaa9b57ab32c41cc3e44c222d406753aea690c77069e322a16fd627"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "677ef6e5fc0ffb61e748e36c2050bd5f7b06ad2654eadff4a249819814eaea7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0c9f1f594c1c97142f9cae0bb112dd0b39b7b9ab80cefa08748120b5217cf51"
    sha256 cellar: :any_skip_relocation, sonoma:         "819898598f0eb80f104feb8155198167041c4e70bab1fae2aefa48e473d55110"
    sha256 cellar: :any_skip_relocation, ventura:        "29a35c5415b5084b9539bf61e3f024c1870a5c845d49e6756b4b0542b2a75d9b"
    sha256 cellar: :any_skip_relocation, monterey:       "42455aa9d158ea9672044809b7fcb2d14d2c4e2e827dba868a6269fd980e4620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eca0c9a9c999c8ed3761b0afb676054622f5011ff66cbc014affe5aeacbfb62b"
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
    assert_match "Hello World", shell_output("#{bin}/runme run foobar")
    assert_match "foobar", shell_output("#{bin}/runme list")
  end
end
