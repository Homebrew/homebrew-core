class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  # homepage site issue report, https://github.com/version-fox/vfox/issues/426
  homepage "https://github.com/version-fox/vfox"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "2aecafe0c056eff8a19677441c0c60499a6b95705990f06484b8f40211a8fea1"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3bf4a5a5a906b1bf01a972c567d34ab32d0eb27df6b70a8a8081cd6ddd0cb97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3bf4a5a5a906b1bf01a972c567d34ab32d0eb27df6b70a8a8081cd6ddd0cb97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3bf4a5a5a906b1bf01a972c567d34ab32d0eb27df6b70a8a8081cd6ddd0cb97"
    sha256 cellar: :any_skip_relocation, sonoma:        "71e0766da73c04b66e11f3fc70ce74c63303b9039a6fb6b4991ce7db960a5857"
    sha256 cellar: :any_skip_relocation, ventura:       "71e0766da73c04b66e11f3fc70ce74c63303b9039a6fb6b4991ce7db960a5857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96146383b75009e2236e9ebdb77936bfc5c8510ae7f2a889ee69bb94378b30e5"
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
