class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  url "https://github.com/vultr/vultr-cli/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "f0aa3f641c8be1278824c1d1a44670cb18ea236d91776a60d27bafb25372137e"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f612a5a74ef871797d961186a4a921d22ca38f384405874a6fa3851be554e356"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3dde6487c06d4ed6af1115578da70933889a6ca77e26de2a763058b0f3e21bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8fa896747c25a1a48320de2ef90944300555a0f924fc4189d2772e9bb129781"
    sha256 cellar: :any_skip_relocation, sonoma:         "2fbd16d52aedf944e134ffe2cd656bdd9548bffff30b0aa72b1d94fff58076bb"
    sha256 cellar: :any_skip_relocation, ventura:        "783c979b602e5343e1cd6607044334f3a29a0f3cb616ad0f9c0c4d2ad30a90e5"
    sha256 cellar: :any_skip_relocation, monterey:       "67d2c7ed2a082582c0f8f2a5a30794bc195b676e4f4d4cc8493b50e00d053658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd62e375cb8e907b8284c743eedd5b61f268b1694085d98a1cf0a1d3345af37d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"vultr", "version"
  end
end
