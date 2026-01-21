class Xc < Formula
  desc "Markdown defined task runner"
  homepage "https://xcfile.dev/"
  url "https://github.com/joerdav/xc/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "afcb5e1fbd1be5f0b6dcb802e02c96527ac0e96ddeb47471b8ad4056f91ccc72"
  license "MIT"
  head "https://github.com/joerdav/xc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f689507921d13ac9c5c3b31858a07034fdde3c9b2745cff3965bba02b8de3b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f689507921d13ac9c5c3b31858a07034fdde3c9b2745cff3965bba02b8de3b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f689507921d13ac9c5c3b31858a07034fdde3c9b2745cff3965bba02b8de3b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e56d4eef3826dcd65197d0b5f38eb49632d374163b59af75695050645018d1f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61c8010926e5f1fa66da4eb63c21dafe8e5f92febd5de72d3d542f309a25c3c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "965b9b02792fdfae0f1072431a50dea31e8df09bde42521c3b2eadb9432b5c09"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/xc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xc --version")

    (testpath/"README.md").write <<~MARKDOWN
      # Tasks

      ## hello
      ```sh
      echo "Hello, world!"
      ```
    MARKDOWN

    output = shell_output("#{bin}/xc hello")
    assert_match "Hello, world!", output
  end
end
