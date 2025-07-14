class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  url "https://github.com/vultr/vultr-cli/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "da6caf170ef61627022d4558e704d9f269a716aa583820ce335d93d2c70d9117"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a2ebbb295ddd6ee824582f0fd7439116d88a79666631689aefa5c7c0d93b933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a2ebbb295ddd6ee824582f0fd7439116d88a79666631689aefa5c7c0d93b933"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a2ebbb295ddd6ee824582f0fd7439116d88a79666631689aefa5c7c0d93b933"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a047f5bdfd5e114ffee5a007b44cbc31122175cc3bb86f7a6700cd7ac96b88a"
    sha256 cellar: :any_skip_relocation, ventura:       "5a047f5bdfd5e114ffee5a007b44cbc31122175cc3bb86f7a6700cd7ac96b88a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "443b8f20566ee720cc7ca4947a2a2c94fd6326a45f63e597c206ec8d850b4e1f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"vultr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vultr version")
    assert_match "Custom", shell_output("#{bin}/vultr os list")
  end
end
