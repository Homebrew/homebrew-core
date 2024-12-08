class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "58f1998c7d03daa30aea7a29c57893c87399d1d722dc5d2349ad3b4f7dc599bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60d17b7ba77afa1f69547b491b183921e93087bf00f5b67d3545ec1045649ac8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98d1a7b2392afe59e044a22f802a4756921d791bb7c19add7ff4cfd0410c9328"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "565b9c748fb390ad26d643667a39d367ccef0283fe2efc254851435fe809eda4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec9f2329e80810f6af6392316219255902ec8823ef74ea08a3b6767e54a7aeed"
    sha256 cellar: :any_skip_relocation, ventura:       "bb3d19ddf3ca86e90d1e4142634486a32bdc5f87a3ae7ccd793a4159f9093ca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10167861f53542b5aeb2c07fc73a484886f7fa28ac3d3cce108f2d813ae38a44"
  end

  depends_on "go" => :build

  conflicts_with "rush", because: "both install `rush` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rush")
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/rush -k 'echo 0{}'", (1..4).to_a.join("\n"))
      01
      02
      03
      04
    EOS
  end
end
