class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "68210f59143c46e868d2de0ca3e37a9a13dfe89bc31346960d28b5d718c650eb"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d6cbdc1f95ee997809877fe128c86db32a2576e596f349a02adaee5dd360b56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8950ee606c61fbcfdf755fe6add70356c3d960ca237095f883a9b48e5760df01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c78b292e24924c81c14dfd1f36d2e4a3b9b90ac312593f1fc5c04662b5b08706"
    sha256 cellar: :any_skip_relocation, sonoma:        "06c5ed847ab099a53d6c9c7a69854fc7110c3116489267fd56496af704bf5c79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d032abc02f2ecdfca7bd06da546ac24d4bcf02959c3fdd1ae95dd87e75258be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3945b2baeb443b9af66d8369a5ede914fe22d915aa87fb0e637ef9715e3b067"
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
