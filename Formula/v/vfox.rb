class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.lhan.me"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "8a081b0f7a58204487bccce9cce26bbe389c2f0f76c67f93f825cafbacd8a837"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d94dc29c3354f5b83270a35b168f8d5783ffc3e300f1e26aa8d43f052fdf6d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96cc7f7f8c43464bf8adc9716e52e733f0c392b923385cc2f681f6c2a233a0d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c16550c97d5cfc78e9e5cbb0d165a41935013b6b2c990758e18994b286a553e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d47553ce015bcccc2ea8cbed0e5d2b6f5d46988f710caf1b6ae494541a5b7c9b"
    sha256 cellar: :any_skip_relocation, ventura:        "95069041ee378fd9f2a90bfc113a1d929c0d922ac556392d032b2c1c3cdf9ca2"
    sha256 cellar: :any_skip_relocation, monterey:       "e7958e460e5e6018895e1703ba85ead948e2687595a36e267340570182139f3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec515c90cd46a1fb6be2cbd9b81d043267764549852a3364cb2f47a8176e2631"
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
