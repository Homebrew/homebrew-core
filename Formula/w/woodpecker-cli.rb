class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "54b61191cc87c2b8a74bbad05e2f259eb5576bd09a75c794de8b86741ba42b23"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbc6c3757e73ef4385f02dc347f08157c8ac25de06edc3becf78b6647b5c4135"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbc6c3757e73ef4385f02dc347f08157c8ac25de06edc3becf78b6647b5c4135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbc6c3757e73ef4385f02dc347f08157c8ac25de06edc3becf78b6647b5c4135"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0831ae63bc32b3f52018e73c7217e54856489b10f201740d8850ad503aaeb1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d30a876f4d1deece3e3f773ac2695c46d91b65f436fba470c71f891c2101e9a3"
    sha256 cellar: :any,                 x86_64_linux:  "6c2f3c076490898ff0fdee100ad6744e2d454a00fdcd4bc2f3d6678168faa544"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
    generate_completions_from_executable(bin/"woodpecker-cli", "completion")
    # woodpecker-cli expects "pwsh", not "powershell" so we use the custom shell_parameter_format
    (pwsh_completion/"woodpecker-cli").write Utils.safe_popen_read(
      { "SHELL" => "pwsh" }, bin/"woodpecker-cli", "completion", "pwsh"
    )
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not set up", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end
