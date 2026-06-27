class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.16.16.tar.gz"
  sha256 "5e621dc53735daee2304e12416c3645ff6b6157b00794ab53be931cdc6f41bb2"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d32bdfbbc2de9c45bf1f9f4d09a09a05f61762f1b9cfeaa6bce9ffa140c2c57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe5644d2f7ec95acf05e6936224aba0c0de615306879c803bff3128da6264468"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e4675792a4ade28ea012c6d403fe0f2f83f45a3e1899f8a88dceb12601068c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dcc71f3ab9a96c06595bd2d11a1f2f1e4a74360a5f315641f255f21c9912e43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cda281702af534807f1168c8a92a192ad1c66802e0cd992461b6e2349cc1991a"
    sha256 cellar: :any,                 x86_64_linux:  "cb58db17d14d5bf0083fd49c6bb940aec7dcce70496967974013ce03285bbaaf"
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
    generate_completions_from_executable(bin/"runme", shell_parameter_format: :cobra)
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
