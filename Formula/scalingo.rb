class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.28.1.tar.gz"
  sha256 "26e93b6843265107487b6e4086857bda5fe6446af8bf3c8cba85c3a47f1345f0"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdbb2875c713f21705a43fab9579d6b21db371f3f7dfe8ba03a584fe84e3c990"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "166dcc9f7b9be08b84ebc227c921b59a76b21711e73a6ee72de85358c8f69dc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9f5d894e574a7b940a27b6caed5e4d6c0fec86878e57acfbafc9bfe2aa93391"
    sha256 cellar: :any_skip_relocation, ventura:        "88cb671d635446a7e0cc86cafd941339cdf99ab81d616961218fd7c02f186498"
    sha256 cellar: :any_skip_relocation, monterey:       "8bf026113dcda14617e42ef4955645939c872e46c3093bbb9ab056c3ccd29808"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ad58102b46cc49c9f00e8c530bff9af37e7d7e53c000e9b4d6b3b505866ca37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bea706555ee2ca0bdcba9a44c4bcbea49d480a7dc2d8fa1326fdc9e5f02cef91"
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
