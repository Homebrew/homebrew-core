class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "f095ecf7174b5cdf25d6e82faecb34fc092a50dbe66e182151b188d3fa6696c9"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f1962768ed29aac485fb70abde10cc5431e18fc076e81fc29ed1ebd2a372636"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca125c328c244d649a77f809f5a2301736afd902825fe117d318d68b03ddb337"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d5402cede05836567a5ffff7b86d839eb77ca8b20cd9bc6b79c515b42f52585"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf0c2e7701fa6536cda39b9e191fcaa236e16704f6fdbd54f5c3185061d20955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c128e8a3aa27fc86cc18c14e497e36e7d78cdf579754019705563e5ab9c6c41d"
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
