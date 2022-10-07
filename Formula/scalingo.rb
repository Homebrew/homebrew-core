class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.26.0.tar.gz"
  sha256 "34e56539e67c296e90ff10ceeaa070c280fbe4528bcfbe3394ba238f9acc1c99"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f459a7e8bdfc991e5c83014be681fb9f35079a5bea3da47c0f8afa83202f3d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76a2b091fa3960c7592748f9262d69e8c6668b1987eb20f142a195192708250a"
    sha256 cellar: :any_skip_relocation, monterey:       "171df85a9431ab27b4fd6093eb677ec43ebcda60b746819fd6ade6d6fbe3c376"
    sha256 cellar: :any_skip_relocation, big_sur:        "06caa466535a00ac3e5e339a46a0571cf3b24ed6cb8ab812f610ed79e68a4877"
    sha256 cellar: :any_skip_relocation, catalina:       "be5054c018835ee8ad0c72a60beeef4bd13282d756d9a52fdaca33984ab29919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47c4e7591664bc8519271eaaf9652ce24f5f662593e3b4eeb609322d7854b36b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"
  end

  test do
    expected = <<~END
      +-------------------+-------+
      | CONFIGURATION KEY | VALUE |
      +-------------------+-------+
      | region            |       |
      +-------------------+-------+
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
