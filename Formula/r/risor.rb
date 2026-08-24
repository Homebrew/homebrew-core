class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/deepnoodle-ai/risor/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "9b6cbb53b629ec9cf7d0c6090c7f7df498f86ed86b8861403b00b1e57dd80ebc"
  license "Apache-2.0"
  head "https://github.com/deepnoodle-ai/risor.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bc21d4e333d70e16c7280b8ac97a47c4ee8316de5e92363ee5667ce7958c488"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bc21d4e333d70e16c7280b8ac97a47c4ee8316de5e92363ee5667ce7958c488"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc21d4e333d70e16c7280b8ac97a47c4ee8316de5e92363ee5667ce7958c488"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea9438d801ad32cfa599c17bc4f8b7f2e05b8063087b115c8cf35cd8e3e10746"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "736a5633f6fc6967a4b47d96cf901a15895a939353e949d34cd7f4ccf9c7e401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e633e2c0ab2d0f0a0822cfb438498172dcd4cafe6e7cc73c57f7c8ae6e264b1"
  end

  depends_on "go" => :build

  def install
    chdir "cmd/risor" do
      ldflags = "-X 'main.version=#{version}' -X 'main.date=#{time.iso8601}'"
      tags = "aws,k8s,vault"
      system "go", "build", *std_go_args(ldflags:, tags:)
      generate_completions_from_executable(bin/"risor", shell_parameter_format: :cobra,
                                                        shells:                 [:bash, :zsh, :fish])
    end
  end

  test do
    output = shell_output("#{bin}/risor -c \"len([1, 2, 3])\"")
    assert_equal "3\n", output
    assert_match version.to_s, shell_output("#{bin}/risor version")

    assert_match "_risor_completion", shell_output("#{bin}/risor completion bash")
    assert_match "unsupported shell: powershell",
                 shell_output("#{bin}/risor completion powershell 2>&1", 1)
  end
end
