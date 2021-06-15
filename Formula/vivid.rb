class Vivid < Formula
  desc "Generator for LS_COLORS with support for multiple color themes"
  homepage "https://github.com/sharkdp/vivid"
  url "https://github.com/sharkdp/vivid/archive/v0.7.0.tar.gz"
  sha256 "8eeb0cd692936558756ce0dea8cc132898029005a5c70118be5e3ccf784b4cfd"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a46eb460f08e5e3714ebe72c4fa9947b40805d6171ff849a1fefe4b92f309d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d94f0e78176eceddb2d4298b2aad7b39a87bc1b2a2f7110e3d14ee9e76a0e99"
    sha256 cellar: :any_skip_relocation, catalina:      "7c4f801eab9c3f5b07aa4585766ce4cd9cf6d55a06f6889ef72a3a044559d834"
    sha256 cellar: :any_skip_relocation, mojave:        "e8766b975c81c7bac8992e8d09b106e3bf2f73b6357a3d3fbc86a2d5c846b06b"
    sha256 cellar: :any_skip_relocation, high_sierra:   "a2fe201c45df0fc3aa4c9a5985d7feeed8f7fca6817b54658e6299da4e604fc9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_includes shell_output("#{bin}/vivid preview molokai"), "archives.images: \e[4;38;2;249;38;114m*.bin\e[0m\n"
  end
end
