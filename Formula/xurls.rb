class Xurls < Formula
  desc "Extract urls from text"
  homepage "https://github.com/mvdan/xurls"
  url "https://github.com/mvdan/xurls/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "8c9850c80eff452eeca2fe0f945a33543302dc31df66c3393ed52f6d8e921702"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/xurls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3046b20d693d80b4c64bb478db3022889a90184833d45e482b350ff736ff3644"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3046b20d693d80b4c64bb478db3022889a90184833d45e482b350ff736ff3644"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3046b20d693d80b4c64bb478db3022889a90184833d45e482b350ff736ff3644"
    sha256 cellar: :any_skip_relocation, ventura:        "28ccbea0f49ee55c5ff0cf51aae01ac92b416cf2783da1621e8a64f2dd5a24f6"
    sha256 cellar: :any_skip_relocation, monterey:       "28ccbea0f49ee55c5ff0cf51aae01ac92b416cf2783da1621e8a64f2dd5a24f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "28ccbea0f49ee55c5ff0cf51aae01ac92b416cf2783da1621e8a64f2dd5a24f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fa5627a447c2260f95c7703f6bfecd823b2a837570da88b831a19226a4f49e4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/xurls"
  end

  test do
    output = pipe_output("#{bin}/xurls", "Brew test with https://brew.sh.")
    assert_equal "https://brew.sh", output.chomp

    output = pipe_output("#{bin}/xurls --fix", "Brew test with http://brew.sh.")
    assert_equal "Brew test with https://brew.sh/.", output.chomp
  end
end
