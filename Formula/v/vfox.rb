class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "193bf86ca67afb00d62dbbe3374512384f777e0e66b60cfbd7f2457990d42034"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abb61bdbd07d4eccea9da1a61a36827530348f4d9af4a71788d46093513a4611"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1cd24232855f98c92ec2d966ff35ef493df564e2fe38126cb7ccdf750bbcc36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "419e23989db1aaa1697a61aad2b49c9c7c5359965c202a7467282ed2d5672d63"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f9ff38b5df8080bfddc2b72af6cfd3f1d577eddebc3374534c2c9d66cffd2c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "947ff25f764c86af353415d0d10e657c76cac88ce35ac1f6b6106e79451807fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b65d83d186f856c6d329d582f48caba5705ad51a29ff7894dc3302f4500a02ff"
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
