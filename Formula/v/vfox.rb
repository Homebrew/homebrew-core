class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.lhan.me"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "e07101dc13a01968b8c63dfb1942fe39c841a801d7b2e06ee528e3ae169ba2b9"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17a8ad3a976f53aed7f1d3c44157df1a9cb20a32b8c0f3befd5eec8cac9184d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b9644e908403404a16afd161e80b5a2d1f672747e3de63c945f87c297fbd8c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ce017836ae2c6254cfc8165b40a8b3ea0d3241327c05be30f66a9422fd3797c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5caa0e226020accbee9630d9ff581e992bcae636dfd93db0ae82e1f3dbd23b05"
    sha256 cellar: :any_skip_relocation, ventura:        "b52635accb5d432d5556cd6a037a295c5ce7d8bb1389ff3e9520bae1f0687cde"
    sha256 cellar: :any_skip_relocation, monterey:       "c00f4da21199d44b8aa6321effc8c212ff208a9e0495b6d415fd44d1090a5171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e20ed996185f0fa516fa78e0e2faf0905606f7a1b5494c48828c54de5a98774d"
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
