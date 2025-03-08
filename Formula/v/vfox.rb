class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  # homepage site issue report, https://github.com/version-fox/vfox/issues/426
  homepage "https://github.com/version-fox/vfox"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "77f277682a850b8312c60c4bcc8cb782486c51ed20272b47ccd64d3ac1f35111"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aec0042954fd8a9a5d4746f17e5d8c4c64ae7cf5048410f8782600a0c03a6dcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aec0042954fd8a9a5d4746f17e5d8c4c64ae7cf5048410f8782600a0c03a6dcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aec0042954fd8a9a5d4746f17e5d8c4c64ae7cf5048410f8782600a0c03a6dcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d499c87ae59c53506f6e8ea4884f0e4a3c50f1ed126231bdaae2a7baa5eebf5f"
    sha256 cellar: :any_skip_relocation, ventura:       "d499c87ae59c53506f6e8ea4884f0e4a3c50f1ed126231bdaae2a7baa5eebf5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68855efd62fa491308346d441e4261b8ee910965fd3b4650b28ef3d430a193d3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "completions/bash_autocomplete" => "vfox"
    zsh_completion.install "completions/zsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfox --version")

    system bin/"vfox", "add", "golang"
    output = shell_output(bin/"vfox info golang")
    assert_match "Golang plugin, https://go.dev/dl/", output
  end
end
