class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "b963215852a93c77a9117e494e6cbafe4e13b0ff1080502cfb1b389b3e4267af"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eda2942a3b045203f9ae5373f41e6e25d7c6229c7c02f0376192c3683295ca87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab9fd1446e07d0b8ec4f51b54238b2e3d8b19154f3989750229a4b507ee0e438"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14898017d305fa7bb4237d61e8d785f774a1a67a06e6d2817e39a8f5be32896e"
    sha256 cellar: :any_skip_relocation, ventura:        "771cb1471a9dc417f9a9baa51f0d789d66eeec7b5790b98a998d63c1539fa111"
    sha256 cellar: :any_skip_relocation, monterey:       "1652be01fab9620feb5b868b38da9cc151fed66b907751931c5067cf5695ebae"
    sha256 cellar: :any_skip_relocation, big_sur:        "81f27169cae1385274168a923077bf3a1e52b88e41236efdfe16a9ce17ffc81d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2f81fe570c14c25fc55028654d6394a776baefe293d13d8a7d0469051a80686"
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
