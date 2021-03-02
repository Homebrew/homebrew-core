class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.12.0.tar.gz"
  sha256 "e27c129152c9454ae2537c866676807a8323c3506682f699bced0ccd4383a9cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "492bd653adbb35233590493af812a2d2e6f087707185670374b5f4b28d0a90a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "534badd4c595a32338bfa1627cf8530b5eec96ac24388e5b6080e57e89f3bd19"
    sha256 cellar: :any_skip_relocation, catalina:      "d8ef7bc535c99083c1e2426ddb99fa107a8b287f389bfd5b882c9239762e17a7"
    sha256 cellar: :any_skip_relocation, mojave:        "6bd79dcc54fe7c42a7834cbde657b4b96edf2fa5a8121536b7f17fe9a6a8cfe8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.Version=#{version}"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
