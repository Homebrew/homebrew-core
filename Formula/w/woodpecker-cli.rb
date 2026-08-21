class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/releases/download/v3.17.0/woodpecker-src.tar.gz"
  sha256 "445245adeb635493300dbd294600782c437e5d4a7ee05240928a865f92d36503"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "516ac5fe19c23f4aa50d315370d0e4dd26962cf3f97b34a3ceec0fde2264d320"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "516ac5fe19c23f4aa50d315370d0e4dd26962cf3f97b34a3ceec0fde2264d320"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "516ac5fe19c23f4aa50d315370d0e4dd26962cf3f97b34a3ceec0fde2264d320"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d22d19e1f5b41f151f6da9d0e045f9e5e22222b0ad92baac23716d4455c77a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cb8241b8419d9f897149138f0cd847d909461eb96b2d2d41722c091c41862f9"
    sha256 cellar: :any,                 x86_64_linux:  "b0f25d599158bf56028875f0138cee9bbbdd16d83466ffc6e21a049a178e1ccf"
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
