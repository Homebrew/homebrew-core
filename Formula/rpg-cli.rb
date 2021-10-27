class RpgCli < Formula
  desc "Your filesystem as a dungeon!"
  homepage "https://github.com/facundoolano/rpg-cli"
  url "https://github.com/facundoolano/rpg-cli/archive/refs/tags/1.0.0.tar.gz"
  sha256 "9131308732b829a9ba7bf307dea3e5fb7ede7671ae206079c89ebcdac34a7da4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "384a050d98cbbc63daf57e1a128a1bdfad36ceeb8c12d2ee6fa64a0a530b8b53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69fe52024f5c2760cdcefc1a79848b69c936609f5d06237ac543913eaf7b1e4c"
    sha256 cellar: :any_skip_relocation, monterey:       "a898df44410ad6b3d549fe2a105fdc233e9e9a93bf135790aabc68c4e886789f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ecfc66dc139d04795813c57df37f9c79c27d8e10d7a91cef218b90f0a8928a4"
    sha256 cellar: :any_skip_relocation, catalina:       "95d3d612a6c9554852eb8a8edc7486a97ce1da7f39fb4f28446adee95ceb538c"
    sha256 cellar: :any_skip_relocation, mojave:         "79088144a5a763bde83334c7749e859e6c5bed0e8ca6a953c9bd1e0073943b9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1a30a0095582ac0007fd4d6acb7e3f558bd962e5336a491dd70af867d502217"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rpg-cli").strip
    assert_match "hp", output
    assert_match "equip", output
    assert_match "item", output
  end
end
