class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "724343df188f8c3e9d77dbe82bf84e528c90abc12f12f02c56180971b8bc31cf"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28ca0696c7aff2bb57f3eb9b256c48fe3aaf2f6207bc56b87c9805d7bcbb6226"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31f88eea2d85faff21aa21c33866b0052cf34fc8a7a0c958cec4f93be5af0b47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb8be8477cbab30c43ec2eab26d519bd369212ccbbd64935d5c4598f34d46771"
    sha256 cellar: :any_skip_relocation, sonoma:        "c64e043085f7550d1fabbd3b77bd50a3f507ec68f3458904dfb087f4132d6010"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf955dc417b693ab5dce13ea3e3824ecd4cb3de969bbb1f130ee43abbc5ce31d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c39444f98d1b2eeec100e54e3700a8c6966368ed9d30377584c4757a98eac66"
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
    output = shell_output("#{bin}/vfox info golang")
    assert_match "Golang plugin, https://go.dev/dl/", output
  end
end
