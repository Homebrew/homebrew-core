class Xc < Formula
  desc "Markdown defined task runner"
  homepage "https://xcfile.dev/"
  url "https://github.com/joerdav/xc/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "142c28aafa454b461b2950d980f0a8a5d89b59fb9032bbe23ca1015472bff691"
  license "MIT"
  head "https://github.com/joerdav/xc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03d65a6b086162b16edbf2c1fdd19712b0d82396c17e6ce51c66f65bbcbad2f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd1805689cb9420c2b7e6430f9f7365e9b58cf815cacc77f6f651d94aced9789"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd1805689cb9420c2b7e6430f9f7365e9b58cf815cacc77f6f651d94aced9789"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd1805689cb9420c2b7e6430f9f7365e9b58cf815cacc77f6f651d94aced9789"
    sha256 cellar: :any_skip_relocation, sonoma:        "53e4ba82822edc0b6fd7644a9671f18a9936db0daa8e021367bbf4dda8f602ba"
    sha256 cellar: :any_skip_relocation, ventura:       "53e4ba82822edc0b6fd7644a9671f18a9936db0daa8e021367bbf4dda8f602ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1399a1f09e5a6191cace90c94185a077f1f22ec82e2a83e4ec7ea5702e0ca56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8a043102c801801a4a603a0aa813513a40d32f957fbfe0355e7c13cb9ede630"
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
