class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/refs/tags/v0.46.1.tar.gz"
  sha256 "3432cf4ea1f0014305d41d4a703f9c0b7910a1d693b32d82191e07ca35b2337d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "195ac14574137eeda9a836845bcb843cb92649249b574bd98e2e2bd686360e64"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b3bf579cec871e27ffd81cece6ae2ff177c1b8ecac6a0a5fe8a7a17c6cdaa50b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ec46e096c89f372a47b1f7e0feceb07dd4d2ac72a169e0857be25a62ea773d20"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1aa1234e86f5bde2e9b8c24a26e6108eadcc2437e50111b40be25a2134c6f69c"
    sha256 cellar: :any,                 x86_64_linux:      "10502913769d6cb3bb737909e583f854d12d96b788e1b954b838ee9bc82565cd"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn"

    generate_completions_from_executable(bin/"tkn", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/tkn pipelinerun describe homebrew-formula 2>&1", 1)
    assert_match "Error: Couldn't get kubeConfiguration namespace", output
  end
end
