class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/releases/download/v3.19.0/woodpecker-src.tar.gz"
  sha256 "9e0a7beb36786d9180c121c95c36ab9b820a44c2b4e417c947ccbde6921baea5"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2d1d0b062570211c5ea157d760725b05c5708093ca79ec7f20b5cfb65e78304"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c2d1d0b062570211c5ea157d760725b05c5708093ca79ec7f20b5cfb65e78304"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c2d1d0b062570211c5ea157d760725b05c5708093ca79ec7f20b5cfb65e78304"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d28ed52b112e5bab20d260aab62e275795507c4d673ee272dc2427a14315a379"
    sha256 cellar: :any,                 x86_64_linux:      "7adf8c055df778b543f09b5432de8848b0c68290bcf99a71b6b19b82f0770072"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ldflags = "-X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
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
