class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/releases/download/v3.18.0/woodpecker-src.tar.gz"
  sha256 "a32586b68e3b078b79f62ca7c8175da93d6d65c9f5d6570e05cc414bcf6622d0"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67766ad1d6d7fc814fbc22303c28927d995af8429e70c8ff7cb8f63a1774a424"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67766ad1d6d7fc814fbc22303c28927d995af8429e70c8ff7cb8f63a1774a424"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67766ad1d6d7fc814fbc22303c28927d995af8429e70c8ff7cb8f63a1774a424"
    sha256 cellar: :any_skip_relocation, sonoma:        "481aebca5ac6ac39ade423cec8511f2fc57baba1faf0df2b194be1167c80ab21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "523ef791000d15eb4acd757742c93999ce8da69fded29116533e53eec11f2820"
    sha256 cellar: :any,                 x86_64_linux:  "4850bdfe9fba6b79f8109daa1926bf1963041bc2327091a8e8c8763151544170"
  end

  depends_on "go" => :build

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
