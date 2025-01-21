class Xc < Formula
  desc "Markdown defined task runner"
  homepage "https://xcfile.dev/"
  url "https://github.com/joerdav/xc/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "374b3d4fe19355a1bc5ba63fd8bc346f027e6a1dbb04af631683ca45a24d806a"
  license "MIT"
  head "https://github.com/joerdav/xc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91d348a6a7d5cf6da756ee17c7e4711f010c16725b71fd01e10cd310e62a9b88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91d348a6a7d5cf6da756ee17c7e4711f010c16725b71fd01e10cd310e62a9b88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91d348a6a7d5cf6da756ee17c7e4711f010c16725b71fd01e10cd310e62a9b88"
    sha256 cellar: :any_skip_relocation, sonoma:        "3209aa028690d1b115b4c19d1b4cbe0d38289abbc3c57f68b97a6311afe34afd"
    sha256 cellar: :any_skip_relocation, ventura:       "3209aa028690d1b115b4c19d1b4cbe0d38289abbc3c57f68b97a6311afe34afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d77bc7fbcefb48acfd459581bd5f354203efa3b41f96c2dae336b9c8c4953548"
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
