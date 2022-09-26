class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.25.1.tar.gz"
  sha256 "8c389f865fbbe3ee977b07b3bc97f62b38cb2719924df7c6db5d8a40e086150c"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51fbc931c7c94ddb91b7a95ac27da7ac729ad6ffb45c1f61c55d2e47533508ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e6dca44aeee4e81b28bb3b297a74eba5c077ed8dac430c117e987f8ba291404"
    sha256 cellar: :any_skip_relocation, monterey:       "1a9496e679acb24168afe8f98ea40e99d9ee95414bc3072f8203c83ac560287a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b86c541d4694c373d5c5807ddf2030e8d763b46640fc8ab117d5cbf4ebbb7437"
    sha256 cellar: :any_skip_relocation, catalina:       "39cec27e624f950cd83c2f199a28dcf9e871afd4502cd8bdffd7ce230d214701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b56e088f9efb9e4e64cab0b3481074555c0040decd2a5f1f165722f9305c57a"
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
