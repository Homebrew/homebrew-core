class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v2.0.13.tar.gz"
  sha256 "3f8c754e2ad72fcf7690242ab04d258781c6918b9283c2f1e88b16665802d950"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53b7cae05540bc9bf794448628f91b20315011cf447ec485171484e7b9ba4c4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53b7cae05540bc9bf794448628f91b20315011cf447ec485171484e7b9ba4c4e"
    sha256 cellar: :any_skip_relocation, monterey:       "218d8f943d8f0006901538acb534ce53cb51c738f103f820c70c8476941d15fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "218d8f943d8f0006901538acb534ce53cb51c738f103f820c70c8476941d15fa"
    sha256 cellar: :any_skip_relocation, catalina:       "218d8f943d8f0006901538acb534ce53cb51c738f103f820c70c8476941d15fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f315d24516a876e451bca5467febe8b70d4d4d0c0e1718569c7a1eb0eddd959e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X github.com/railwayapp/cli/constants.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Account required to init project", output
  end
end
