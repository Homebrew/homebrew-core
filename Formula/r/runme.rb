class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme.git",
      tag:      "v1.7.2",
      revision: "4fdf96517c7a54aab95151e50319039fb0ef4417"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29511f84f9d18706f5bfd0a8e39a18aff50a023badf98854b2ecacf5aecd5e88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b40dbf3a034f5c98f908656f366a2b11e1db9e79640473ff3ba09f502f4f5e0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1c63e0e58a54090de1c659eb05df8bd0241eed079679783c593d3f9a3362906"
    sha256 cellar: :any_skip_relocation, ventura:        "9d281c25e590f2fa515e10638fb684c58bf7f2c04cec99d248166b40ec557623"
    sha256 cellar: :any_skip_relocation, monterey:       "33b8022ad7fb11b16a7532eac2f3f1b70ec43797ba666aa7ba0afae53ebfb4e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8bddb11a0f6e8a9bd7d7668027202dce344ed9c4e5dd8c372bb96d1c408ee9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb44625767a1793c92b22c1388edee7a5445065616ddaf86d786e5eaf98fbd4"
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
