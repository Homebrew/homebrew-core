class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "988a97844402a01887dbdc45322b2dbc6e0db70005bd79b4b2c361377286cc93"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29ddf974131be640a7db3a368a622b3e4b6d08c30b4f937fac6c5040389df2f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7ba9881e12303c8849c37b1b946c3d2f2ab1a06dd2af9c1c00a42803f96032d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88596f7207ab10bd6307d00ad972534c5091059224fd57e67e91b65a1acfdcd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "bab2938f6d88cb205b2b658060413e92081a181a112f1475763df1e468382283"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8710189fb91d88b9d0da7969f7c2bd6a7ce818990e07cb9b9f193e5a323910db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba0448f71d526de320fb3bb0f29aeab67129087e60ad4c076cbb178bf51d6565"
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
