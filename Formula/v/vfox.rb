class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "a201d35eec1465bf571f80ea65c27c74c61e2a5ce96c97b5f0e45f2dbfa86a34"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69890410a3bd1bf0a3713d051080834b75e9f0d7a6c8820a9050890dd65a9276"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db62c1d48fc63366b538503c0547031b8b672c05a2572efb2d24797c7c173f22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45541f695d69baa81859eecbeaa6a656e6b4e59382f3bceab8093add0d232bac"
    sha256 cellar: :any_skip_relocation, sonoma:        "50d89f00234675b47ea92536ec0435791d43f74a72361460557a0bdf0fe5281b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7124f73212f71bc4e8427914cb82c66eb30e6bad5e75116b7b43bc49957fa4ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa64805f938b39440fcba1a3e564c863e10b1d2d71846cc59ce85533c24891bf"
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
