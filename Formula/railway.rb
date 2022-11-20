class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v2.0.13.tar.gz"
  sha256 "3f8c754e2ad72fcf7690242ab04d258781c6918b9283c2f1e88b16665802d950"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7363a99d8efff786a578f68fc3753d66888d8a8c37e82c2b55a512f01528c812"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7363a99d8efff786a578f68fc3753d66888d8a8c37e82c2b55a512f01528c812"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7363a99d8efff786a578f68fc3753d66888d8a8c37e82c2b55a512f01528c812"
    sha256 cellar: :any_skip_relocation, ventura:        "9c05049b013ff3cddcbc7518cd2da2e4d414093553b8a90a6b7411efc69be02e"
    sha256 cellar: :any_skip_relocation, monterey:       "dd920e81026a98a7fc5e346183c143d5157829915950103214ea090b83dfaf4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd920e81026a98a7fc5e346183c143d5157829915950103214ea090b83dfaf4b"
    sha256 cellar: :any_skip_relocation, catalina:       "dd920e81026a98a7fc5e346183c143d5157829915950103214ea090b83dfaf4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37595a9a560287a465b5c6c9e6acdf28238a81cb266e9f9b721cdcf5cc43295a"
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
