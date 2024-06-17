class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.8.4.tar.gz"
  sha256 "f576cb8210544db15f8e7e1a05d2b1ebd5a8d8f76add4067f66169aca86ffd78"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6fb6be463e24cf8d35fae4837ff7676a31c8ebfd13d82084c493dd4a114f74e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60e35ce719bac6b5f070b903e74e0e5322dc2c5959a9d363c25c212b321106c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c616b8d6bf9a2b1310d68ac610beceaf935873b972b58636e810db6d2d1cf44e"
    sha256 cellar: :any_skip_relocation, sonoma:         "52f086fe006cd25e6f7a5db65f876e4b7ac61e4d45230233cadf399d019bd5e6"
    sha256 cellar: :any_skip_relocation, ventura:        "26af403262c27c76a1d9a21e9babab067b3955b71cbf655d5b73740726986af3"
    sha256 cellar: :any_skip_relocation, monterey:       "6a50989f1f574dda1598816f0b5a81fe9205baa3d7319e3a3df47bd17d149e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97439c31ca027ff004477e3f77946a17e1d9c3ed6ae753f88f5dbcc4fec30418"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}"), "-o", bin/"rancher"
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end
