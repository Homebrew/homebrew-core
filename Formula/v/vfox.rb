class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "0ebd9ebd3e2c49f286cde749664b67665849360e193b2f78633223ffe57e5f54"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f7686da7d7d19d26904f0619adcbd6e93be6b0605d9ab12f813a5484633e2204"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c371dc0e90b8e6298d7184d423845d8f5e59fda3d2018a2e0a9c499f2f0762b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a356161e940da69a33a3f3e83d100512387d695d3e3f5ce1758d88a087d4371d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "83a5d50dd4ef89ff06b082520f3720122f6a7af484a229397974e8b6e9e5a33a"
    sha256 cellar: :any,                 x86_64_linux:      "427ae257cf0a9f737fb11d7ccbbeb37ed21ab75ac85da08258abef3050f829eb"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

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
