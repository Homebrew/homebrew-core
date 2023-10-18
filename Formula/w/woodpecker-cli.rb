class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "c4581e31ea639694c5193d9d7fa66c92585135a48bdf560c97de7f183141a208"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59b3dd9fbd57f449b87eaf1a098a09dc06cca5fcbaab539ca97287511eba86d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5669287ae9beeac511ce97023b6f88ef6019268fd4f3110e2f8d2a5e7080800"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5800bae12735ae0d42b815b50fd2b536daf731d60260cf1a1f2c7a612d5e6d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4bf345f143c7d12424995c0ab1ef7011632bc316477ff95b896e02e6580d2ce"
    sha256 cellar: :any_skip_relocation, ventura:        "bbbda7ddb55154bd745e739117738451863f6e32688bd376a06f6cd83af49895"
    sha256 cellar: :any_skip_relocation, monterey:       "f3088346c4c68fd6542f610584e3e5b59f08863f1996ef893d812177696d6f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eebddd1dcc4061a965a90aa6c0e129b428e838437d79ec05c9130763e6bd682d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/woodpecker-ci/woodpecker/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "Error: you must provide the Woodpecker server address", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end
