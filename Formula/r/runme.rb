class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "a8d0ae742d101481c182c5f5744b275720c800a6bf88fb6a3a83f359f868495f"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9af1ab700cdd2e4b1b613b6263c484421ef78c4d60a8bbef3d8c14ba05dd109"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd4dc299984175913551530a3c5c5ecb3a331e5af4047285165396c9ecdfc77d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46d83eb211225af188c5f5332a7910027ee37842bfaa6dc24d56717c35a3db55"
    sha256 cellar: :any_skip_relocation, sonoma:         "9958c8c3994caac460af127d300e7a15b6568d277c0f3a031c89b67b9fbb32bd"
    sha256 cellar: :any_skip_relocation, ventura:        "62569f621f2d7952c04e55275d749361291140e279bfedd33ce3cf7776b329b4"
    sha256 cellar: :any_skip_relocation, monterey:       "b3d52ae70a34d722e7b882031e717372e25d529310b060b4485be946ae5286e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62cdfb8869bda8f0e916627abd7bd9c0bdf24baa7dfb74ba72d67fba1a08cc8e"
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
