class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v2.0.12.tar.gz"
  sha256 "ba4183b0a7c59d4b381bc0bb9ea70700d773775cf387c5d3fab54f22a3fba304"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "befa8ea65c627fb3f516190b3d9d4c07b83288a88efa05c810b15ae5d8120aec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "befa8ea65c627fb3f516190b3d9d4c07b83288a88efa05c810b15ae5d8120aec"
    sha256 cellar: :any_skip_relocation, monterey:       "7540c56f12ea6912685267df68024f43afee1deef7085f8505c6a60e63009b79"
    sha256 cellar: :any_skip_relocation, big_sur:        "7540c56f12ea6912685267df68024f43afee1deef7085f8505c6a60e63009b79"
    sha256 cellar: :any_skip_relocation, catalina:       "7540c56f12ea6912685267df68024f43afee1deef7085f8505c6a60e63009b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee7769685c960709ac2fc9156cd1d4873cc1ecc8fd53d72b6b5e443bd48f8829"
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
