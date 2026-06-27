class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v3.15.0.tar.gz"
  sha256 "14acf419b5a8b349fc73662ac272e238b8492477911ad27c95701f8efbbdc5c2"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb2935fca19a06b02a8f3bd54cf1883642c9bb19f2110e833112a7dd38134a46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb2935fca19a06b02a8f3bd54cf1883642c9bb19f2110e833112a7dd38134a46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb2935fca19a06b02a8f3bd54cf1883642c9bb19f2110e833112a7dd38134a46"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba8a3c6c7b5f140c7ce7bbb3f2430cb64d53d335ef8a943434b10890b0e3c768"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f607d6523a605145992a8fd91edb79d2f19aa72180f284ab6af9edf9fee6304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea82afa883bb00c9128d2dc6114c6557f8f1ab8ab1bf820a73336869edccf68c"
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
