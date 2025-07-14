class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v0.6.10.tar.gz"
  sha256 "397c93d5bc8284128c1d8e7271c95cf7f15d0744f2886bd99ce39b1601257574"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac7a526467aba9c94a9df7326186f0235878690ac1d1b1a5d9772091dfdcd1a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14b8adf71ffb0325a6ef6534f10195425266d90e968ba58186fa8ff607f3e6d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ce85e7a6dcda29250e6cf585f7bc7f59d04e88edaa5b4011669278545c1582f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed86405b888156e41eb62a72e417ecd9aba5b665ed4e2f792c7a083804d03c06"
    sha256 cellar: :any_skip_relocation, ventura:       "6a62694771e5e7464706830449ec689f7e2e8fff9dbae05ed2e12c46836b343f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37089fdad736c695de04ed6d7aadf8c1e21fc69b5f910ef7f3069b9c042bdf89"
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
