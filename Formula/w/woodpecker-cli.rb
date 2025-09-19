class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "f4d2b24346c928f29cf57ad00e22a591525a01573a869ffc9f0f58f884b357d1"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81fa0a15a126f01b96bcce40ee69a6e2dfbcd0d80e380427ae78db102fac37b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cf041562b531e9052dffc1e702e10865ae488ab7c1a1d3a27fffb90d6fe94d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cf041562b531e9052dffc1e702e10865ae488ab7c1a1d3a27fffb90d6fe94d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8cf041562b531e9052dffc1e702e10865ae488ab7c1a1d3a27fffb90d6fe94d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4eee62d5e28ae38f11a211d7bac59f5438f34fcfb24ec7b072609837821cbbe"
    sha256 cellar: :any_skip_relocation, ventura:       "a4eee62d5e28ae38f11a211d7bac59f5438f34fcfb24ec7b072609837821cbbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6b2abdeb1da21f1dc1246416f405238f7c166739a305638d10fb5a43dd9ced2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not set up", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end
