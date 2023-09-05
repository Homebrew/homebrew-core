class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "bc60ba4653298a904679df2ca80c49f1f580c6aa238951d00bf13a9e30807d3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5cbdc1c37c4be7adf095b9563decc377277187d7edec2795334a8e3f7fe01fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "899841a1daa64609c5f317f75b4c4a9ac3bc67fd1551baa7ceb9cd916b9bc794"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d1a58653893f6e243a7debca6d1ba1ea391be9dbdb5a83e27d01c19ed41bd1c"
    sha256 cellar: :any_skip_relocation, ventura:        "67e529988d61acc691d983a99a99e6808594259186c05ec38c072af3cdcb33bb"
    sha256 cellar: :any_skip_relocation, monterey:       "c4422022d18f3910037c980d74535cd0b5fd49344018a369b3548259b1377788"
    sha256 cellar: :any_skip_relocation, big_sur:        "34c84caff2c8b54062f72bce223b5680f07c2ad0af1fb533fd3a553440073143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dd362dea1ff8fd0db3d9a4c36cb12f86e77f5deccefad7a194199b065b49122"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"rush")
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
