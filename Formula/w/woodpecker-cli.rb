class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "ffc0fc1745caa10c1f98d47ed409aad40563d1a89a0282d1ac68b07108300c3b"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "836fe95f69ed42bc1181e8fb471e436ecbc43217d7f5e9053e8e5647c42fa8b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "673897e8f2a29698310bc831e909b86e4597db49b2069844bc2cab6cfe89a2fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1abb29bc060973036238c9b502f155bef68210c2e663ad37242de961c8f0316"
    sha256 cellar: :any_skip_relocation, sonoma:         "724cc0ee027311720497aaad2409b0d873cff919e1c3bcb230d3d9ece1f49c97"
    sha256 cellar: :any_skip_relocation, ventura:        "0d8a4c026187c06bd0e0e10cbdbbc3f515cf6a6013f98090661673361b3e9c48"
    sha256 cellar: :any_skip_relocation, monterey:       "ab405dd0d91514516c516325a9aabca38141994c23fc2ee6e41aaea0036c73ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f86913ec7be998c16fcd0fe9c0a26323f0cdf3e1579e90ef1a93b9d14b670d6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "you must provide the Woodpecker server address", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end
