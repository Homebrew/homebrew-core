class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "54dc09cb1e1b9670bce1e0730a5b19eccd2494f381b0026b13cd1339bdf3607c"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cdd5322acffbb7ee18313f339ed8b63723499888d1906f840cce59e85e7fd5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e9c74f5ba947cc8236e6d14c3993438776ca109d816f13846396b80a1360229"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36e1eb9f3ed54ea67fdf9696c544329a4877ed443acf664e8aa6c8b52351a7db"
    sha256 cellar: :any_skip_relocation, sonoma:         "fafc1b9ecce4df8188fcccacbacf33a8b548980c396344e216b66ba95e4e1e20"
    sha256 cellar: :any_skip_relocation, ventura:        "daa61ea57e113cecdd8057407b381da6135880c9d6f2547f7f7c464fd91b5120"
    sha256 cellar: :any_skip_relocation, monterey:       "0f1510db1c38ba804bc6d6ec855bc7c877ebdd2799577342f2c4ef6072465199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d99d430a95631c65267f324cd899577457111aa0dd40c991c8e89355f687fb5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not yet set up", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end
