class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "a6e8d6373fef6cf1a684197dffebb665ef85b5be9b461ad13519c392c9e2944e"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "266098a13d333ad4270c72345c7e0d41652bd7a25cba1ce6607c9ffd14c93aea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86e5358361c1443601f3598a5514ed1cca237411cc4cd21b74db96736acfe883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a45b7398dfef7a7afe5a54e67381d51c6a5fbfbd650ad70b9601e95df10e7df"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8045c25770e3460c2d5d1ad7eadec712a9c2164e8844ead23b4be4f42026a02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9569c0b5f57c4b323ce3b2334885c4d0d9824e340d8379797b9759d7950ca522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c434e6a30089e4c4a28bb7f8ab6e60a7ebedfd6eed13fd07bd45ba32b6cbfa5b"
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
