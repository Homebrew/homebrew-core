class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/deepnoodle-ai/risor/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "68aea48e715636482a24b1f5aa6505152c89f339374a4e8225cd1d83edc14ec7"
  license "Apache-2.0"
  head "https://github.com/deepnoodle-ai/risor.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "408a5f4219a77976b126cbe0646aaa9827d252fb01934d2d6d53f2e97bbac270"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f7bef7deebd4731e5d35247bf11634995fe6f8143ac1ce8bb6272587b9ec734"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1916fd748d446b003dc941675879f94dd6016f29f56e086dddca7faf3a6c3ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "64993ffcab950ef5a0bf2794ddb69ceddb5334536d0cf9c55159b68bb0b1da73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef43e3c3c8efc1d84e2982b7edc30b50e0955af1aec6f2fd0452c6df69842ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4aaaf7d78b1f909ebd7e17e3beb011b07fac18df4d4238b77ad8d477feaf16b"
  end

  depends_on "go" => :build

  def install
    chdir "cmd/risor" do
      ldflags = "-s -w -X 'main.version=#{version}' -X 'main.date=#{time.iso8601}'"
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
