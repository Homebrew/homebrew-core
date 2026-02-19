class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/deepnoodle-ai/risor/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "053fd2a8057d4387ae746047f7f22dabe8c8c75f1fa1cee0ded50a74f33bb5f9"
  license "Apache-2.0"
  head "https://github.com/deepnoodle-ai/risor.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe4875177ceb4868f14ff03e02b5dcfdacfa56f52517d582663c2efdba78045d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "200be41219159bf9b33dad0945c748551289485756554dd61eea558373979680"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eaf0e96ca81603aa79b2e3209b4ecf416900aae43997d963cdb801b48f96ea2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f5ae5b5b7b03e64e6fc9f340cbd3761cc4f7f3840b450ec152b3be433b2fc3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "023d71c0661a3037c08604127baa194b3509ebbedb155519febb3307aedcc6a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76b0edb8e90d14a4b563f1289a1164c1785fa39bbf5ccef59bc358eb461ebfc1"
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
