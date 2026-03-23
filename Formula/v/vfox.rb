class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "9dde247005a6d287460a2309e8688403c14e4e80e9ac096ba48839f8b2bcce96"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c43c80b348584b57b9954b278f74459a2169a7b36fa992e2fc63c64033c6fc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4c85c6144c2a84eb646e5a3be5ef1d1ffdedf42d6d3613060380f055861e002"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34e228fcaeb63d09aef4de6e13157e94009d354d1da69cd2e936b75abb644d06"
    sha256 cellar: :any_skip_relocation, sonoma:        "34932b5b21cc994b79e51e3649b743dbe4575f39e177012bd5648a26a3b6d914"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbf4b8c817d90adeac7c55dcb4ba058b71a6549b84e26273221d895e0b56677d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7e1e3889e688f5962d3363f804f22cff2d829132a2c78b30aee9673944a4fe3"
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
