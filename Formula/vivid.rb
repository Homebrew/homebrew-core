class Vivid < Formula
  desc "Generator for LS_COLORS with support for multiple color themes"
  homepage "https://github.com/sharkdp/vivid"
  url "https://github.com/sharkdp/vivid/archive/v0.6.0.tar.gz"
  sha256 "c8640f524aef1cd4dc15286bdc6189894ad067ea79bf8c40b9ca8d9d752d161f"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    cellar :any_skip_relocation
    sha256 "7c4f801eab9c3f5b07aa4585766ce4cd9cf6d55a06f6889ef72a3a044559d834" => :catalina
    sha256 "e8766b975c81c7bac8992e8d09b106e3bf2f73b6357a3d3fbc86a2d5c846b06b" => :mojave
    sha256 "a2fe201c45df0fc3aa4c9a5985d7feeed8f7fca6817b54658e6299da4e604fc9" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_includes shell_output("#{bin}/vivid preview molokai"), "archives.images: \e[4;38;2;249;38;114m*.bin\e[0m\n"
  end
end
